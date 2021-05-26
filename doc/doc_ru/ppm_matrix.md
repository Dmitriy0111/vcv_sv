# ppm_matrix

������ ���� �������� �������� ������ ��� ������ � ppm �������� �����������. 

���������:
```Verilog
class ppm_matrix extends base_matrix;
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
����������� ������ ��� �������� ���������� ppm_matrix.

���������:
```Verilog
function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});
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
������ ��� �������� ������ �� ����� � �������. �������� �������� ��� ������ ��������� ppm �����.

���������:
```Verilog
task load_matrix();
```

#### save_matrix
������ ��� ���������� ������ �� �������� � ����. �������� �������� ��� ������ ��������� ppm �����.

���������:
```Verilog
task save_matrix();
```

#### create
������� ��� �������� ������ �����������.

���������:
```Verilog
static function ppm_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});
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