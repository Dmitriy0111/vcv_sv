# pat_matrix

������ ���� �������� �������� ������ ������������ ����������� �������� �����������. 

���������:
```Verilog
class pat_matrix extends base_matrix;
```

## ���� � �������/������ ������ 

������ ����� ��������� ���� � �������/������ �� �������� ������ ����������� [base_matrix.md](base_matrix.md).

### �������/������:
| ���           | ��������                                  |
| ------------- | ----------------------------------------- |
| new           | ����������� ������                        |
| load_matrix   | ������ ��� �������� ������ �� �����       |
| save_matrix   | ������ ��� ���������� ������ � ����       |
| gen_data      | ������ ��� ������������ ��������          |
| create        | ������� ��� �������� ������ �����������   |

### �������� �������/�����:

#### new
����������� ������ ��� �������� ���������� pat_matrix.

���������:
```Verilog
function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});
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
������ ��� �������� ������ �� ����� � �������. �������� ����� ������� ��� ��������� ��������.

���������:
```Verilog
task load_matrix();
```

#### save_matrix
������ ��� ���������� ������ �� �������� � ����. ����� ������ ������� ������� � ���������� �������� ���������.

���������:
```Verilog
task save_matrix();
```

#### gen_data
������ ��� ������������ ��������. ����� ����� ����������� ��������� ��������: "RGB_columns", "RGB_grad_columns", "RGB_lines", "RGB_grad_lines", "8bit_columns", "8bit_lines", "BW_columns", "BW_lines", "Grad", "Random", "Archimed".

���������:
```Verilog
task gen_data();
```

#### create
������� ��� �������� ������ �����������.

���������:
```Verilog
static function pat_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});
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