# image

Данный файл содержит описание файла [image.c](../../ver_classes/dpi_src/image.c), содержащего импортируемые в SystemVerilog код функции через DPI-C. 

Зависимости:
```C
#include "../dpi_h/dpiheader.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"
```

## Переменные и функции 

### Поля:
| Имя       | Тип               | Описание                  |
| --------- | ----------------- | ------------------------- |
| image_p   | unsigned char *   | Указатель на изображение  |

### Функции:
| Имя                   | Описание                                              |
| --------------------- | ----------------------------------------------------- |
| dpi_open_image        | Функция для открытия изображения                      |
| dpi_get_pix           | Функция для получения значения пикселя                |
| dpi_free_image        | Функция для освобождения ресурсов                     |
| dpi_create_image      | Функция для инициализации указателя на изображение    |
| dpi_store_img         | Функция для задания значений пикселей изображения     |
| dpi_save_image_jpg    | Функция для сохранения изображения в формате jpg      |
| dpi_save_image_png    | Функция для сохранения изображения в формате png      |
| dpi_save_image_bmp    | Функция для сохранения изображения в формате bmp      |
| dpi_save_image_tga    | Функция для сохранения изображения в формате tga      |

### Описание функций/задач:

#### dpi_open_image
Функция для открытия файла изображения с заданным путём.

Заголовок:
```C
int dpi_open_image(const char* path, int width, int height);
```

Аргументы:
| Имя       | Тип           | Описание                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | Путь к файлу изображения  |
| width     | int           | Ширина изображения        |
| height    | int           | Высота изображения        |

#### dpi_get_pix
Функция для получения цвета пикселя.

Заголовок:
```C
int dpi_get_pix(int pix_pos, unsigned int * R, unsigned int * G, unsigned int * B);
```

Аргументы:
| Имя       | Тип               | Описание                          |
| --------- | ----------------- | --------------------------------- |
| pix_pos   | int               | Номер пикселя в изображении       |
| R         | unsigned int *    | Указатель на красный цвет пикселя |
| G         | unsigned int *    | Указатель на зелёный цвет пикселя |
| B         | unsigned int *    | Указатель на синий цвет пикселя   |

#### dpi_free_image
Функция для освобождения ресурсов.

Заголовок:
```C
int dpi_free_image();
```

#### dpi_create_image
Функция для инициализации указателя на изображение (image_p).

Заголовок:
```C
int dpi_create_image(int width, int height);
```

Аргументы:
| Имя       | Тип   | Описание              |
| --------- | ----- | --------------------- |
| width     | int   | Ширина изображения    |
| height    | int   | Высота изображения    |

#### dpi_store_img
Функция для задания значений пикселей изображения.

Заголовок:
```C
void dpi_store_img(int Width, int Height, svOpenArrayHandle R, svOpenArrayHandle G, svOpenArrayHandle B);
```

Аргументы:
| Имя       | Тип               | Описание                          |
| --------- | ----------------- | --------------------------------- |
| width     | int               | Ширина изображения                |
| height    | int               | Высота изображения                |
| R         | svOpenArrayHandle | Массив красного цвета изображения |
| G         | svOpenArrayHandle | Массив зелёного цвета изображения |
| B         | svOpenArrayHandle | Массив синего цвета изображения   |

#### dpi_save_image_jpg
Функция для сохранения изображения в формате jpg.

Заголовок:
```C
void dpi_save_image_jpg(const char* path, int width, int height);
```

Аргументы:
| Имя       | Тип           | Описание                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | Путь к файлу изображения  |
| width     | int           | Ширина изображения        |
| height    | int           | Высота изображения        |

#### dpi_save_image_png
Функция для сохранения изображения в формате png.

Заголовок:
```C
void dpi_save_image_png(const char* path, int width, int height);
```

Аргументы:
| Имя       | Тип           | Описание                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | Путь к файлу изображения  |
| width     | int           | Ширина изображения        |
| height    | int           | Высота изображения        |

#### dpi_save_image_bmp
Функция для сохранения изображения в формате bmp.

Заголовок:
```C
void dpi_save_image_bmp(const char* path, int width, int height);
```

Аргументы:
| Имя       | Тип           | Описание                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | Путь к файлу изображения  |
| width     | int           | Ширина изображения        |
| height    | int           | Высота изображения        |

#### dpi_save_image_tga
Функция для сохранения изображения в формате tga.

Заголовок:
```C
void dpi_save_image_tga(const char* path, int width, int height);
```

Аргументы:
| Имя       | Тип           | Описание                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | Путь к файлу изображения  |
| width     | int           | Ширина изображения        |
| height    | int           | Высота изображения        |