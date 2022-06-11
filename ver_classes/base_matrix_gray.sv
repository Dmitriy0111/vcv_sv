/*
*  File            :   base_matrix_gray.sv
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is base matrix class
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

`ifndef BASE_MATRIX_GRAY__SV
`define BASE_MATRIX_GRAY__SV

`timescale 1ps/1ps

class base_matrix_gray #(parameter int CW = 8);

    gist_c              gist = new();
        
    bit     [CW-1 : 0]  GRAY [];

    // Matrix Height, Width and Resolution
    int                 Height;
    int                 Width;
    int                 Resolution;
    // Pixel position and counter
    int                 p_x = 0;
    int                 p_y = 0;
    int                 p_c = 0;
    // cycle variable
    int                 cycle;          // Current cycle variable
    // variable's for working with files
    int                 fd;             // file descriptor
    string              path2folder;    // path to folder with storing/loading images
    string              image_name;     // sub-image name
    string              cycle_s = "";   // current cycle variable (string)
    string              fn;             // image full name
    string              out_format[$];
    string              in_format;

    extern function new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".data", string out_format_i[]={".data"});

    extern virtual function int get_width();
    extern virtual function int get_height();

    extern virtual task set_width(int Width_i);
    extern virtual task set_height(int Height_i);

    extern virtual function void create_matrix();
    extern virtual task free_matrix();

    extern virtual function string path2file(string format);

    extern virtual task load_matrix();
    extern virtual task save_matrix();

    extern virtual function void set_gray(int x, int y, bit [CW-1 : 0] pixel_gray);
    extern virtual function bit  set_image_gray(bit [CW-1 : 0] pixel_gray);

    extern virtual function void get_gray(ref bit [CW-1 : 0] pixel_gray, input int x, int y);
    extern virtual function bit  get_image_gray(ref bit [CW-1 : 0] pixel_gray);

    extern virtual task cycle_inc();

    extern virtual task reset_pos();

    extern virtual task clnpix();

    static function base_matrix_gray #(CW) create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".data", string out_format_i[] = {".data"});
        base_matrix_gray #(CW) ret_matrix = new(Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i);
        return ret_matrix;
    endfunction : create

endclass : base_matrix_gray

function base_matrix_gray::new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".data", string out_format_i[]={".data"});
    Height = Height_i;
    Width  = Width_i; 
    Resolution = Width * Height;
    in_format = in_format_i;

    out_format.delete();
    foreach( out_format_i[i] )
        out_format.push_back( out_format_i[i] );

    this.create_matrix();
    // reset pixel position and counter
    p_x = '0;
    p_y = '0;
    p_c = '0;
    // reset cycle
    cycle = '0;
    // init help variables
    path2folder = path2folder_i;
    image_name = image_name_i;

    $timeformat(-12,3,"ps",20);
endfunction : new

function int base_matrix_gray::get_width();
    return this.Width;
endfunction : get_width

function int base_matrix_gray::get_height();
    return this.Height;
endfunction : get_height

task base_matrix_gray::set_width(int Width_i);
    this.Width = Width;
endtask : set_width

task base_matrix_gray::set_height(int Height_i);
    this.Height = Height_i;
endtask : set_height

function void base_matrix_gray::create_matrix();
    // creating one-dimensional array
    GRAY = new [Resolution];
endfunction : create_matrix

task base_matrix_gray::free_matrix();
    GRAY.delete();
endtask : free_matrix

// function for getting current name
function string base_matrix_gray::path2file(string format);
    cycle_s.itoa( cycle );  // converting cycle (int) to cycle_s (string)
    return  {
                path2folder,
                image_name,
                cycle_s,
                format
            };
endfunction : path2file

task base_matrix_gray::load_matrix();
    int err_cnt = 0;
    do
    begin
        fn = path2file( ".data" );
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

    for( int j = 0 ; j < Height ; j++ )
        for( int i = 0 ; i < Width ; i++ )
            $fscanf( fd, "%d ", GRAY[i+j*Width] );

    $fclose( fd );
endtask : load_matrix

task base_matrix_gray::save_matrix();
    fn = path2file( ".data" );

    fd = $fopen( fn, "wb" );

    if( !fd ) begin
        $display( "file is not open!" );
        $stop;
    end
    
    for( int j = 0 ; j < Height ; j++ )
        for( int i = 0 ; i < Width ; i++ )
            $fwrite( fd, "%d ", GRAY[i+j*Width] );

    $fflush( fd );
    $fclose( fd );

    cycle_inc();
endtask : save_matrix

function void base_matrix_gray::set_gray(int x, int y, bit[CW-1 : 0] pixel_gray);
    GRAY[x+Width*y] = pixel_gray;
endfunction : set_gray

function bit base_matrix_gray::set_image_gray(bit[CW-1 : 0] pixel_gray);
    bit eoi = '0;    // end of image

    p_c++;
    this.set_gray( p_x, p_y, pixel_gray );
    p_x++;

    if( p_x == this.Width )
    begin
        p_x = '0;
        p_y++;
    end

    if( p_c == this.Resolution )
    begin
        eoi = '1;
        p_x = '0;
        p_y = '0;
        p_c = '0;
        $display("Image received at %t", $time);
    end

    return eoi;
endfunction : set_image_gray

function void base_matrix_gray::get_gray(ref bit [CW-1 : 0] pixel_gray, input int x, int y);
    pixel_gray = GRAY[x+Width*y];
endfunction : get_gray

function bit base_matrix_gray::get_image_gray(ref bit [CW-1 : 0] pixel_gray);
    bit eoi = '0;    // end of image
    p_c++;
    this.get_gray( pixel_gray, p_x, p_y );
    p_x++;
    if( p_x == this.Width )
    begin
        p_x = '0;
        p_y++;
    end
    if( p_c == this.Resolution )
    begin
        eoi = '1;
        p_x = '0;
        p_y = '0;
        p_c = '0;
    end
    return eoi;
endfunction : get_image_gray

task base_matrix_gray::cycle_inc();
    this.cycle++;
endtask : cycle_inc

task base_matrix_gray::reset_pos();
    p_x = 0;
    p_y = 0;
    p_c = 0;
endtask : reset_pos

task base_matrix_gray::clnpix();
    foreach(GRAY[i])
        GRAY[i] = '0;
endtask : clnpix

`endif // BASE_MATRIX_GRAY__SV
