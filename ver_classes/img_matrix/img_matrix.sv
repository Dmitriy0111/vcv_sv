/*
*  File            :   img_matrix.sv
*  Autor           :   Vlasov D.V
*  Data            :   01.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is test matrix file for testing video ip cores
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

`ifndef IMG_MATRIX__SV
`define IMG_MATRIX__SV

`timescale 1ps/1ps

// Make C function visible to verilog code
import "DPI-C" function int dpi_open_image(input string path, input int width, input int height);
import "DPI-C" function int dpi_get_pix(input int pix_pos, output int unsigned R, output int unsigned G, output int unsigned B);
import "DPI-C" function int dpi_free_image();

import "DPI-C" function int  dpi_create_image(input int width, input int height);
import "DPI-C" function void dpi_store_img(input int Width, input int Height, input bit[7:0] R[][], input bit[7:0] G[][], input bit[7:0] B[][]);
import "DPI-C" function void dpi_save_image_jpg(input string path, input int width, input int height);
import "DPI-C" function void dpi_save_image_png(input string path, input int width, input int height);
import "DPI-C" function void dpi_save_image_bmp(input string path, input int width, input int height);
import "DPI-C" function void dpi_save_image_tga(input string path, input int width, input int height);
    
class img_matrix extends base_matrix;

    // tasks and functions
    extern function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});

    extern task save_matrix();
    extern task load_matrix();

    extern static function img_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});

endclass : img_matrix

function img_matrix::new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});
    super.new( Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i );

    $timeformat(-12,3,"ps",20);
endfunction : new

task img_matrix::save_matrix();
    dpi_create_image( Width, Height );
    dpi_store_img( Width, Height, R, G, B );
    foreach( out_format[i] )
        case( out_format[i] )
            ".jpg"  :   
            begin 
                fn = path2file( ".jpg" );
                dpi_save_image_jpg( fn, Width, Height );
            end
            ".png"  :   
            begin 
                fn = path2file( ".png" );
                dpi_save_image_png( fn, Width, Height );
            end
            ".bmp"  :   
            begin 
                fn = path2file( ".bmp" );
                dpi_save_image_bmp( fn, Width, Height );
            end
            ".tga"  :   
            begin 
                fn = path2file( ".tga" );
                dpi_save_image_tga( fn, Width, Height );
            end
            default :
            begin
                $fatal("Unexpected format!");
            end
        endcase
    dpi_free_image();
    cycle_inc();
endtask : save_matrix

task img_matrix::load_matrix();
    int err;
    int err_cnt = '0;
    
    do
    begin
        fn = path2file( in_format );
        err = dpi_open_image( fn, Width, Height );
        if( err == 1 )
        begin
            cycle = '0;
            err_cnt++;
            if( err_cnt == 7 )
                $fatal("Input file opening error! Simulation stop!");
        end
    end
    while( err != 0 );

    foreach( R[i,j] )
        dpi_get_pix( ( i + j * Width ) * 3 , R[i][j] , G[i][j] , B[i][j] );

    dpi_free_image();

    $display( "next image loaded at time %t", $time );
    cycle_inc();
endtask : load_matrix

function img_matrix img_matrix::create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".jpg", string out_format_i[] = {".jpg"});
    img_matrix ret_matrix = new(Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i);
    return ret_matrix;
endfunction : create

`endif // IMG_MATRIX__SV
