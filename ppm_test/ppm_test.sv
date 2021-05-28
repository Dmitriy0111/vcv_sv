/*
*  File            :   ppm_test.sv
*  Autor           :   Vlasov D.V
*  Data            :   20.02.2021
*  Language        :   SystemVerilog
*  Description     :   This is testbench with save/load tasks for ppm images
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

module ppm_test;

    timeunit            1ns;
    timeprecision       1ns;

    bit     [7 : 0]     R_out [][];
    bit     [7 : 0]     G_out [][];
    bit     [7 : 0]     B_out [][];

    bit     [7 : 0]     R_in [][];
    bit     [7 : 0]     G_in [][];
    bit     [7 : 0]     B_in [][];

    int                 Height_out;
    int                 Width_out;

    int                 Height_in;
    int                 Width_in;

    string              fn;
    string              out_format;
    string              in_format;

    task automatic save_matrix(string fn_, string out_format_, int Height_, int Width_, ref bit [7 : 0] R_[][], ref bit [7 : 0] G_[][], ref bit [7 : 0] B_[][]);
        int fd;
    
        fd = $fopen( fn_, "wb" );
    
        if( !fd )
        begin
            $display( "File is not open!" );
            $stop;
        end
        
        $fwrite( fd, { out_format_ , "\n# ppm_matrix file\n" } );
        $fwrite( fd, "%d %d\n255\n", Width_, Height_ );
        
        if( out_format_ == "P3" )
            for( int j = 0 ; j < Height_ ; j++ )
                for( int i = 0 ; i < Width_ ; i++ )
                    $fwrite( fd, "%d %d %d\n", R_[i][j], G_[i][j], B_[i][j] );
        else
            for( int j = 0 ; j < Height_ ; j++ )
                for( int i = 0 ; i < Width_ ; i++ )
                    $fwrite( fd, "%c%c%c", R_[i][j], G_[i][j], B_[i][j] );
    
        $fflush( fd );
        $fclose( fd );
    
    endtask : save_matrix

    task automatic load_matrix(string fn_, ref string in_format_, ref int Height_, ref int Width_, ref bit [7 : 0] R_[][], ref bit [7 : 0] G_[][], ref bit [7 : 0] B_[][]);
        int fd;
        
        int max_v;
    
        fd = $fopen( fn_, "rb" );
        if( fd == 0 )
        begin
            $display("Input file opening error! Simulation stop!");
            $stop;
        end
    
        $fscanf( fd, "%s", in_format_ );
        
        repeat(2)
            while( $fgetc(fd) != 'h0a );
    
        $fscanf( fd, "%d %d", Width_, Height_ );
        
        $fscanf( fd, "%d", max_v );
    
        if( in_format_ == "P3" )
            for( int j = 0 ; j < Height_ ; j++ )
                for( int i = 0 ; i < Width_ ; i++ )
                    $fscanf( fd, "%d %d %d", R_[i][j], G_[i][j], B_[i][j] );
        else
        begin
            $fgetc( fd );
            for( int j = 0 ; j < Height_ ; j++ )
                for( int i = 0 ; i < Width_ ; i++ )
                    $fscanf( fd, "%c%c%c", R_[i][j], G_[i][j], B_[i][j] );
        end
    
        $fclose( fd );
    
    endtask : load_matrix

    initial
    begin
        Width_out = 1024;
        Height_out = 768;
        fn = "../output_images/test.ppm";
        R_out = new [Width_out];
        G_out = new [Width_out];
        B_out = new [Width_out];

        foreach(R_out[i])
            R_out[i] = new [Height_out];
        foreach(G_out[i])
            G_out[i] = new [Height_out];
        foreach(B_out[i])
            B_out[i] = new [Height_out];

        Width_in = 1024;
        Height_in = 768;

        R_in = new [Width_in];
        G_in = new [Width_in];
        B_in = new [Width_in];

        foreach(R_in[i])
            R_in[i] = new [Height_in];
        foreach(G_in[i])
            G_in[i] = new [Height_in];
        foreach(B_in[i])
            B_in[i] = new [Height_in];

        foreach(R_out[i,j])
            R_out[i][j] = i;
        foreach(G_out[i,j])
            G_out[i][j] = j;
        foreach(B_out[i,j])
            B_out[i][j] = i+j;

        save_matrix(fn, "P3",Height_out,Width_out,R_out,G_out,B_out);

        load_matrix("../input_images/in_image_0.ppm", in_format, Height_in,Width_in,R_in,G_in,B_in);

        foreach(R_out[i,j])
            R_out[i][j] = ( R_in[i][j] + R_out[i][j] ) / 2;
        foreach(G_out[i,j])
            G_out[i][j] = ( G_in[i][j] + G_out[i][j] ) / 2;
        foreach(B_out[i,j])
            B_out[i][j] = ( B_in[i][j] + B_out[i][j] ) / 2;

        save_matrix("../output_images/plus_out_image_0.ppm", in_format,Height_in,Width_in,R_out,G_out,B_out);

        foreach(R_in[i,j])
            R_in[i][j] = ~R_in[i][j];
        foreach(G_in[i,j])
            G_in[i][j] = ~G_in[i][j];
        foreach(B_in[i,j])
            B_in[i][j] = ~B_in[i][j];

        save_matrix("../output_images/not_out_image_0.ppm", in_format,Height_in,Width_in,R_in,G_in,B_in);
        $stop;
    end

endmodule : ppm_test
