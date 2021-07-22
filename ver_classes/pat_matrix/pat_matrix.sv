/*
*  File            :   pat_matrix.sv
*  Autor           :   Vlasov D.V
*  Data            :   26.02.2021
*  Language        :   SystemVerilog
*  Description     :   This is class for generating pattern images
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

`ifndef PAT_MATRIX__SV
`define PAT_MATRIX__SV

`timescale 1ps/1ps

class pat_matrix extends base_matrix;

    extern function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});

    extern task load_matrix();
    extern task save_matrix();
    
    extern task gen_data();

    extern static function pat_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});

endclass : pat_matrix

function pat_matrix::new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});
    super.new( Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i );

    $timeformat(-12,3,"ps",20);
endfunction : new

task pat_matrix::load_matrix();
    gen_data();
endtask : load_matrix

task pat_matrix::save_matrix();
    $display("Pattern matrix doesnt have save method");
    $fatal();
endtask : save_matrix

task pat_matrix::gen_data();
    $display("Generating matrix start at time %t", $time);
    case( in_format )
        "Black_screen":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = '0;
                G[i][j] = '0;
                B[i][j] = '0;
            end
        end
        "White_screen":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = '1;
                G[i][j] = '1;
                B[i][j] = '1;
            end
        end
        "RGB_columns":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = ( i <  ( Width / 3     ) ) ? '1 : '0;
                G[i][j] = ( i <= ( Width / 3 * 2 ) ) && 
                          ( i >= ( Width / 3     ) ) ? '1 : '0;
                B[i][j] = ( i >  ( Width / 3 * 2 ) ) ? '1 : '0;
            end
        end
        "RGB_grad_columns":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = ( i <  ( Width / 3     ) ) ? i : '0;
                G[i][j] = ( i <= ( Width / 3 * 2 ) ) && 
                          ( i >= ( Width / 3     ) ) ? i : '0;
                B[i][j] = ( i >  ( Width / 3 * 2 ) ) ? i : '0;
            end
        end
        "RGB_lines":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = ( j <  ( Height / 3     ) ) ? '1 : '0;
                G[i][j] = ( j <= ( Height / 3 * 2 ) ) && 
                          ( j >= ( Height / 3     ) ) ? '1 : '0;
                B[i][j] = ( j >  ( Height / 3 * 2 ) ) ? '1 : '0;
            end
        end
        "RGB_grad_lines":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = ( j <  ( Height / 3     ) ) ? j : '0;
                G[i][j] = ( j <= ( Height / 3 * 2 ) ) && 
                          ( j >= ( Height / 3     ) ) ? j : '0;
                B[i][j] = ( j >  ( Height / 3 * 2 ) ) ? j : '0;
            end
        end
        "8bit_columns":
        begin
            int rgb = 0;
            int col_w = Width / 8;
            int next_c;
            foreach(R[i,j])
            begin
                if( i == 0 )
                begin
                    rgb = 0;
                    next_c = col_w;
                end
                if( i > next_c )
                begin
                    rgb++;
                    next_c += col_w;
                end
                R[i][j] = { 8 {rgb[2]} };
                G[i][j] = { 8 {rgb[1]} };
                B[i][j] = { 8 {rgb[0]} };
            end
        end
        "8bit_lines":
        begin
            int rgb = 0;
            int line_h = Height / 8;
            int next_l;
            foreach(R[i,j])
            begin
                if( j == 0 )
                begin
                    rgb = 0;
                    next_l = line_h;
                end
                if( j > next_l )
                begin
                    rgb++;
                    next_l += line_h;
                end
                R[i][j] = { 8 {rgb[2]} };
                G[i][j] = { 8 {rgb[1]} };
                B[i][j] = { 8 {rgb[0]} };
            end
        end
        "BW_columns":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = ( i % 2 ) == 0 ? '1 : '0;
                G[i][j] = ( i % 2 ) == 0 ? '1 : '0;
                B[i][j] = ( i % 2 ) == 0 ? '1 : '0;
            end
        end
        "BW_lines":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = ( j % 2 ) == 0 ? '1 : '0;
                G[i][j] = ( j % 2 ) == 0 ? '1 : '0;
                B[i][j] = ( j % 2 ) == 0 ? '1 : '0;
            end
        end
        "Grad":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = i;
                G[i][j] = j;
                B[i][j] = i+j;
            end
        end
        "Random":
        begin
            foreach(R[i,j])
            begin
                R[i][j] = $random();
                G[i][j] = $random();
                B[i][j] = $random();
            end
        end
        "Archimed":
        begin
            int x_c, y_c;
            int pos_x, pos_y;
            real angle = 0;
            x_c = Width / 2;
            y_c = Height / 2;
            foreach(R[i,j])
            begin
                R[i][j] = '1;
                G[i][j] = '1;
                B[i][j] = '1;
            end
            while(1)
            begin
                pos_x = x_c + 3 * ( angle * 3.14 / 360 ) * $cos(angle * 3.14 / 360);
                pos_y = y_c + 3 * ( angle * 3.14 / 360 ) * $sin(angle * 3.14 / 360);
                angle += 0.1;
                if  ( 
                        ( ( pos_x < 0     ) && ( pos_y < 0      ) ) ||
                        ( ( pos_x < 0     ) && ( pos_y > Height ) ) ||
                        ( ( pos_x > Width ) && ( pos_y < 0      ) ) ||
                        ( ( pos_x > Width ) && ( pos_y > Height ) )
                    )
                    break;
                if  ( 
                        ( pos_x >= 0     ) ||
                        ( pos_x < Width  ) ||
                        ( pos_y >= 0     ) ||
                        ( pos_y < Height )
                    )
                begin
                    R[pos_x][pos_y] = '0;
                    G[pos_x][pos_y] = '0;
                    B[pos_x][pos_y] = '0;
                end
            end
        end
        default:
        begin
            $display("Unexpected generation!");
            $stop;
        end
    endcase
    $display("Generating matrix complete at time %t", $time);
endtask : gen_data

function pat_matrix pat_matrix::create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "Grad", string out_format_i[] = {"NONE"});
    pat_matrix ret_matrix = new(Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i);
    return ret_matrix;
endfunction : create

`endif // PAT_MATRIX__SV
