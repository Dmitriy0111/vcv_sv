# image

������ ���� �������� �������� ����� [image.c](../../ver_classes/dpi_src/image.c), ����������� ������������� � SystemVerilog ��� ������� ����� DPI-C. 

�����������:
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

## ���������� � ������� 

### ����:
| ���       | ���               | ��������                  |
| --------- | ----------------- | ------------------------- |
| image_p   | unsigned char *   | ��������� �� �����������  |

### �������:
| ���                   | ��������                                              |
| --------------------- | ----------------------------------------------------- |
| dpi_open_image        | ������� ��� �������� �����������                      |
| dpi_get_pix           | ������� ��� ��������� �������� �������                |
| dpi_free_image        | ������� ��� ������������ ��������                     |
| dpi_create_image      | ������� ��� ������������� ��������� �� �����������    |
| dpi_store_img         | ������� ��� ������� �������� �������� �����������     |
| dpi_save_image_jpg    | ������� ��� ���������� ����������� � ������� jpg      |
| dpi_save_image_png    | ������� ��� ���������� ����������� � ������� png      |
| dpi_save_image_bmp    | ������� ��� ���������� ����������� � ������� bmp      |
| dpi_save_image_tga    | ������� ��� ���������� ����������� � ������� tga      |

### �������� �������/�����:

#### dpi_open_image
������� ��� �������� ����� ����������� � �������� ����.

���������:
```C
int dpi_open_image(const char* path, int width, int height);
```

���������:
| ���       | ���           | ��������                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | ���� � ����� �����������  |
| width     | int           | ������ �����������        |
| height    | int           | ������ �����������        |

#### dpi_get_pix
������� ��� ��������� ����� �������.

���������:
```C
int dpi_get_pix(int pix_pos, unsigned int * R, unsigned int * G, unsigned int * B);
```

���������:
| ���       | ���               | ��������                          |
| --------- | ----------------- | --------------------------------- |
| pix_pos   | int               | ����� ������� � �����������       |
| R         | unsigned int *    | ��������� �� ������� ���� ������� |
| G         | unsigned int *    | ��������� �� ������ ���� ������� |
| B         | unsigned int *    | ��������� �� ����� ���� �������   |

#### dpi_free_image
������� ��� ������������ ��������.

���������:
```C
int dpi_free_image();
```

#### dpi_create_image
������� ��� ������������� ��������� �� ����������� (image_p).

���������:
```C
int dpi_create_image(int width, int height);
```

���������:
| ���       | ���   | ��������              |
| --------- | ----- | --------------------- |
| width     | int   | ������ �����������    |
| height    | int   | ������ �����������    |

#### dpi_store_img
������� ��� ������� �������� �������� �����������.

���������:
```C
void dpi_store_img(int Width, int Height, svOpenArrayHandle R, svOpenArrayHandle G, svOpenArrayHandle B);
```

���������:
| ���       | ���               | ��������                          |
| --------- | ----------------- | --------------------------------- |
| width     | int               | ������ �����������                |
| height    | int               | ������ �����������                |
| R         | svOpenArrayHandle | ������ �������� ����� ����������� |
| G         | svOpenArrayHandle | ������ ������� ����� ����������� |
| B         | svOpenArrayHandle | ������ ������ ����� �����������   |

#### dpi_save_image_jpg
������� ��� ���������� ����������� � ������� jpg.

���������:
```C
void dpi_save_image_jpg(const char* path, int width, int height);
```

���������:
| ���       | ���           | ��������                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | ���� � ����� �����������  |
| width     | int           | ������ �����������        |
| height    | int           | ������ �����������        |

#### dpi_save_image_png
������� ��� ���������� ����������� � ������� png.

���������:
```C
void dpi_save_image_png(const char* path, int width, int height);
```

���������:
| ���       | ���           | ��������                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | ���� � ����� �����������  |
| width     | int           | ������ �����������        |
| height    | int           | ������ �����������        |

#### dpi_save_image_bmp
������� ��� ���������� ����������� � ������� bmp.

���������:
```C
void dpi_save_image_bmp(const char* path, int width, int height);
```

���������:
| ���       | ���           | ��������                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | ���� � ����� �����������  |
| width     | int           | ������ �����������        |
| height    | int           | ������ �����������        |

#### dpi_save_image_tga
������� ��� ���������� ����������� � ������� tga.

���������:
```C
void dpi_save_image_tga(const char* path, int width, int height);
```

���������:
| ���       | ���           | ��������                  |
| --------- | ------------- | ------------------------- |
| path      | const char *  | ���� � ����� �����������  |
| width     | int           | ������ �����������        |
| height    | int           | ������ �����������        |