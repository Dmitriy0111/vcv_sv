/*
*  File            :   pgm_matrix.sv
*  Autor           :   Vlasov D.V
*  Data            :   11.06.2022
*  Language        :   SystemVerilog
*  Description     :   This is class for working with pgm image format file
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

`ifndef PGM_MATRIX__SV
`define PGM_MATRIX__SV

`timescale 1ps/1ps

class pgm_matrix #(parameter int CW = 8) extends base_matrix_gray #(CW);

    extern function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});

    extern task load_matrix();
    extern task save_matrix();

    extern static function pgm_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});

endclass : pgm_matrix

function pgm_matrix::new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});
    super.new( Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i );

    $timeformat(-12,3,"ps",20);
endfunction : new

task pgm_matrix::load_matrix();
    
    int H,W;
    int max_v;
    int err_cnt = '0;
    logic [CW-1 : 0] Gray_int;

    do
    begin
        fn = path2file( ".pgm" );
        fd = $fopen( fn, "rb" );
        if( fd == 0 )
        begin
            cycle = '0;
            err_cnt++;
            if( err_cnt == 7 )
                $fatal("Input file opening error! Simulation stop!");
        end
    end
    while( fd == 0 );

    $fscanf( fd, "%s", in_format );
    
    repeat(2)
        while( $fgetc(fd) != 'h0a );

    $fscanf( fd, "%d %d", W, H );

    if( ( W != Width ) || ( H != Height ) )
    begin
        Width = W;
        Height = H;
        free_matrix();
        create_matrix();
    end
    
    $fscanf( fd, "%d", max_v );

    if( in_format == "P2" )
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
                begin
                    if(CW<=8) begin
                        $fscanf( fd, "%d ", Gray_int );  
                        GRAY[i+j*Width] = Gray_int;
                    end
                    else begin
                        $fscanf( fd, "%d %d ", Gray_int[15 : 8] , Gray_int[7 : 0] );  
                        GRAY[i+j*Width] = Gray_int;
                    end
                end
    /*else if( in_format == "P5" )
    begin
        $fgetc( fd );
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
                $fscanf( fd, "%c%c%c", R[i][j], G[i][j], B[i][j] );
    end*/
    else
        $fatal("Unexpected PGM format!");

    $fclose( fd );

endtask : load_matrix

task pgm_matrix::save_matrix();
    logic [CW-1 : 0] Gray_int;

    fn = path2file( ".pgm" );

    fd = $fopen( fn, "wb" );

    if( !fd )
    begin
        $display( "file is not open" );
        $stop;
    end
    
    $fwrite( fd, { out_format[0] , "\n# pgm_matrix file\n" } );
    $fwrite( fd, "%d %d\n255\n", Width, Height );
    
    if( out_format[0] == "P2" )
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
                begin
                    if(CW<=8) begin
                        Gray_int = GRAY[i+j*Width];
                        $fwrite( fd, "%d ", Gray_int );
                    end
                    else begin
                        Gray_int = GRAY[i+j*Width];
                        $fwrite( fd, "%d %d ", Gray_int[15 : 8], Gray_int[7 : 0] );
                    end
                end
    /*else if( out_format[0] == "P5" )
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
                $fwrite( fd, "%c%c%c", R[i][j], G[i][j], B[i][j] );*/
    else
        $fatal("Unexpected PPM format!");

    $fflush( fd );
    $fclose( fd );

    $display( "next image loaded at time %t", $time );
    cycle_inc();
endtask : save_matrix

function pgm_matrix pgm_matrix::create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[] = {"P3"});
    pgm_matrix ret_matrix = new(Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i);
    return ret_matrix;
endfunction : create

`endif // PGM_MATRIX__SV
