# pat_matrix

Данный файл содержит описание класса формирующего определённые паттерны изображения. 

Заголовок:
```Verilog
class pat_matrix extends base_matrix;
```

## Поля и функции/задачи класса 

Данный класс наследует поля и функции/задачи из базового класса изображения [base_matrix.md](base_matrix.md).

### Функции/задачи:
| Имя           | Описание                                  |
| ------------- | ----------------------------------------- |
| new           | Конструктор класса                        |
| load_matrix   | Задача для загрузки данных из файла       |
| save_matrix   | Задача для сохранения данных в файл       |
| gen_data      | Задача для формирования паттерна          |
| create        | Функция для создания класса изображения   |

### Описание функций/задач:

#### new
Конструктор класса для создания экземпляра pat_matrix.

Заголовок:
```Verilog
function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});
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
Задача для загрузки данных из файла в массивы. Содержит вызов функции для генерации паттерна.

Заголовок:
```Verilog
task load_matrix();
```

#### save_matrix
Задача для сохранения данных из массивов в файл. Вызов данной функции приведёт к завершению процесса симуляции.

Заголовок:
```Verilog
task save_matrix();
```

#### gen_data
Задача для формирования паттерна. Класс умеет формировать следующие паттерны: "RGB_columns", "RGB_grad_columns", "RGB_lines", "RGB_grad_lines", "8bit_columns", "8bit_lines", "BW_columns", "BW_lines", "Grad", "Random", "Archimed".

Заголовок:
```Verilog
task gen_data();
```

#### create
Функция для создания класса изображения.

Заголовок:
```Verilog
static function pat_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});
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