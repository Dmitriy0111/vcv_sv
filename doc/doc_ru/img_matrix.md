# img_matrix

������ ���� �������� �������� ������ ��� ������ � jpg, tga, bmp, png ��������� ����������� ����� DPI-C. 

���������:
```Verilog
class img_matrix extends base_matrix;
```

## ���� � �������/������ ������ 

������ ����� ��������� ���� � �������/������ �� �������� ������ ����������� [base_matrix.md](base_matrix.md).

### �������/������:
| ���           | ��������                                  |
| ------------- | ----------------------------------------- |
| new           | ����������� ������                        |
| load_matrix   | ������ ��� �������� ������ �� �����       |
| save_matrix   | ������ ��� ���������� ������ � ����       |
| create        | ������� ��� �������� ������ �����������   |

### �������� �������/�����:

#### new
����������� ������ ��� �������� ���������� img_matrix.

���������:
```Verilog
function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});
```

���������:
| ���           | ���       | ��������                          |
| ------------- | --------- | --------------------------------- |
| Width_i       | int       | ������ �����������                |
| Height_i      | int       | ������ �����������                |
| path2folder_i | string    | ���� � ����� �����������          |
| image_name_i  | string    | ��� �����������                   |
| in_format_i   | string    | ������� ������ �����              |
| out_format_i  | string [] | ������� �������� �������� �����   |

#### load_matrix
������ ��� �������� ������ �� ����� � �������. �������� �������� ��� ������ ������� �������� ����� ����������� ����� DPI-C � ���������� �������� �����������.

���������:
```Verilog
task load_matrix();
```

#### save_matrix
������ ��� ���������� ������ �� �������� � ����. �������� �������� ��� ������� ������� �������� �������� ������ � ������ ��������������� ������� ���������� ����������� ����� DPI-C.

���������:
```Verilog
task save_matrix();
```

#### create
������� ��� �������� ������ �����������.

���������:
```Verilog
static function img_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});
```

���������:
| ���           | ���       | ��������                          |
| ------------- | --------- | --------------------------------- |
| Width_i       | int       | ������ �����������                |
| Height_i      | int       | ������ �����������                |
| path2folder_i | string    | ���� � ����� �����������          |
| image_name_i  | string    | ��� �����������                   |
| in_format_i   | string    | ������� ������ �����              |
| out_format_i  | string [] | ������� �������� �������� �����   |

## �����������

��� ����� ������ �������� ������ ������� ����� DPI-C:
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

������ �� ��������������� ������� ������ ��� ����������� �����.