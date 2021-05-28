# img_matrix

Данный файл содержит описание класса для работы с jpg, tga, bmp, png форматами изображений через DPI-C. 

Заголовок:
```Verilog
class img_matrix extends base_matrix;
```

## Поля и функции/задачи класса 

Данный класс наследует поля и функции/задачи из базового класса изображения [base_matrix.md](base_matrix.md).

### Функции/задачи:
| Имя           | Описание                                  |
| ------------- | ----------------------------------------- |
| new           | Конструктор класса                        |
| load_matrix   | Задача для загрузки данных из файла       |
| save_matrix   | Задача для сохранения данных в файл       |
| create        | Функция для создания класса изображения   |

### Описание функций/задач:

#### new
Конструктор класса для создания экземпляра img_matrix.

Заголовок:
```Verilog
function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});
```

Аргументы:
| Имя           | Тип       | Описание                          |
| ------------- | --------- | --------------------------------- |
| Width_i       | int       | Ширина изображения                |
| Height_i      | int       | Высота изображения                |
| path2folder_i | string    | Путь к папке изображений          |
| image_name_i  | string    | Имя изображения                   |
| in_format_i   | string    | Входной формат файла              |
| out_format_i  | string [] | Очередь выходных форматов файла   |

#### load_matrix
Задача для загрузки данных из файла в массивы. Содержит алгоритм для вызова функции открытия файла изображения через DPI-C и заполнения массивов изображения.

Заголовок:
```Verilog
task load_matrix();
```

#### save_matrix
Задача для сохранения данных из массивов в файл. Содержит алгоритм для анализа очереди форматов выходных файлов и вызова соответствующих функций сохранения изображений через DPI-C.

Заголовок:
```Verilog
task save_matrix();
```

#### create
Функция для создания класса изображения.

Заголовок:
```Verilog
static function img_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});
```

Аргументы:
| Имя           | Тип       | Описание                          |
| ------------- | --------- | --------------------------------- |
| Width_i       | int       | Ширина изображения                |
| Height_i      | int       | Высота изображения                |
| path2folder_i | string    | Путь к папке изображений          |
| image_name_i  | string    | Имя изображения                   |
| in_format_i   | string    | Входной формат файла              |
| out_format_i  | string [] | Очередь выходных форматов файла   |

## Особенности

Код файла класса содержит импорт функций через DPI-C:
```Verilog
import "DPI-C" function int dpi_open_image(input string path, input int width, input int height);
import "DPI-C" function int dpi_get_pix(input int pix_pos, output int unsigned R, output int unsigned G, output int unsigned B);
import "DPI-C" function int dpi_free_image();

import "DPI-C" function int  dpi_create_image(input int width, input int height);
import "DPI-C" function void dpi_store_img(input int Width, input int Height, input bit[7:0] R[][], input bit[7:0] G[][], input bit[7:0] B[][]);
import "DPI-C" function void dpi_save_image_jpg(input string path, input int width, input int height);
import "DPI-C" function void dpi_save_image_png(input string path, input int width, input int height);
import "DPI-C" function void dpi_save_image_bmp(input string path, input int width, input int height);
import "DPI-C" function void dpi_save_image_tga(input string path, input int width, input int height);
```

Каждая из импортированных функций служит для определённых целей.