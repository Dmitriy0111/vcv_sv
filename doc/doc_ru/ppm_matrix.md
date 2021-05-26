# ppm_matrix

Данный файл содержит описание класса для работы с ppm форматом изображения. 

Заголовок:
```Verilog
class ppm_matrix extends base_matrix;
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
Конструктор класса для создания экземпляра ppm_matrix.

Заголовок:
```Verilog
function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});
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
Задача для загрузки данных из файла в массивы. Содержит алгоритм для чтения структуры ppm файла.

Заголовок:
```Verilog
task load_matrix();
```

#### save_matrix
Задача для сохранения данных из массивов в файл. Содержит алгоритм для записи структуры ppm файла.

Заголовок:
```Verilog
task save_matrix();
```

#### create
Функция для создания класса изображения.

Заголовок:
```Verilog
static function ppm_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});
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