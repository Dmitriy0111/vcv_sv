/*
*  File            :   ppm_matrix.sv
*  Autor           :   Vlasov D.V
*  Data            :   12.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is class for working with ppm image format file
*  Copyright(c)    :   2019-2020 Vlasov D.V
*/

`ifndef PPM_MATRIX__SV
`define PPM_MATRIX__SV

`timescale 1ns/100ps

class ppm_matrix extends base_matrix;

    extern function     new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[]={"P3"});

    extern task         load_matrix();
    extern task         save_matrix();

endclass : ppm_matrix

// class constructor
function ppm_matrix::new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "P3", string out_format_i[]={"P3"});
    super.new( Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i );
endfunction : new

task ppm_matrix::load_matrix();
    
    int H,W;
    int max_v;
    int err_cnt = '0;
    logic [7 : 0] R_int, G_int, B_int;

    do
    begin
        fn = path2file( ".ppm" );
        fd = $fopen( fn, "rb" );
        if( fd == 0 )
        begin
            cycle = '0;
            err_cnt++;
            if( err_cnt == 7 )
            begin
                $display("Input file opening error! Simulation stop!");
                $stop;
            end
        end
    end
    while( fd == 0 );

    $fscanf( fd, "%s", in_format );
    
    repeat(2)
        while( $fgetc(fd) != 'h0a );

    $fscanf( fd, "%d %d", H, W );
    
    $fscanf( fd, "%d", max_v );

    if( in_format == "P3" )
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
				begin					
					$fscanf( fd, "%d %d %d", R_int, G_int, B_int );  
                	R[i][j] = R_int; G[i][j] = G_int; B[i][j] = B_int;  
				end
    else
    begin
        $fgetc( fd );
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
                $fscanf( fd, "%c%c%c", R[i][j], G[i][j],B[i][j] );
    end

    $fclose( fd );

endtask : load_matrix

task ppm_matrix::save_matrix();

    fn = path2file( ".ppm" );

    fd = $fopen( fn, "wb" );

    if( !fd )
    begin
        $display( "file is not open" );
        $stop;
    end
    
    $fwrite(fd, { out_format[0] , "\n# ppm_matrix file\n" } );
    $fwrite( fd, "%d %d\n255\n", Width, Height );
    
    if( out_format[0] == "P3" )
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
                $fwrite( fd, "%d %d %d\n", R[i][j], G[i][j], B[i][j] );
    else
        for( int j = 0 ; j < Height ; j++ )
            for( int i = 0 ; i < Width ; i++ )
                $fwrite( fd, "%c%c%c", R[i][j], G[i][j], B[i][j] );

    $fflush( fd );
    $fclose( fd );

    cycle++;

endtask : save_matrix

`endif // PPM_MATRIX__SV
