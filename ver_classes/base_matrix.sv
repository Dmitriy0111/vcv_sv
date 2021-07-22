/*
*  File            :   base_matrix.sv
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is base matrix class
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

`ifndef BASE_MATRIX__SV
`define BASE_MATRIX__SV

`timescale 1ps/1ps

class base_matrix;

    gist_c              gist = new();
        
    bit     [7 : 0]     R [][];
    bit     [7 : 0]     G [][];
    bit     [7 : 0]     B [][];

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
    // R G B R G B R G B
    real    rgb2ycbcr_coefs [9] = { 
                                      0.257 ,   0.504 ,   0.098,
                                    - 0.148 , - 0.291 ,   0.439,
                                      0.439 , - 0.368 , - 0.071
                                };
    // R G B
    int     rgb2ycbcr_offs[3] = { 16, 128, 128 };
    // Y Cb Cr Y Cb Cr Y Cb Cr
    real    ycbcr2rgb_coefs [9] = { 
                                    1.164 ,   0.000 ,   1.596,
                                    1.164 , - 0.392 , - 0.813,
                                    1.164 ,   2.017 ,   0.000
                                };
    // Y Cb Cr
    int     ycbcr2rgb_offs[3] = { -16, -128, -128 };

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

    extern virtual function void set_RGB(int x, int y, bit [23 : 0] pixel_rgb);
    extern virtual function bit  set_image_RGB(bit [23 : 0] pixel_rgb);

    extern virtual function bit [23 : 0] get_RGB(int x, int y);
    extern virtual function bit          get_image_RGB(ref bit [23 : 0] pixel_rgb);

    extern virtual function bit set_image_Bayer(bit [7 : 0] Bayer);
    extern virtual function bit get_image_Bayer(ref bit [7 : 0] Bayer);

    extern virtual task copy_arrays(base_matrix oth_matrix);

    extern virtual task mix_arrays(base_matrix oth_matrix);

    extern virtual task find_and_save_gist();

    extern virtual task cycle_inc();

    extern virtual task reset_pos();

    extern virtual task rgb2ycbcr();
    extern virtual task ycbcr2rgb();

    extern virtual task clnpix();

    extern static function base_matrix create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".data", string out_format_i[] = {".data"});

endclass : base_matrix

function base_matrix::new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".data", string out_format_i[]={".data"});
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

function int base_matrix::get_width();
    return this.Width;
endfunction : get_width

function int base_matrix::get_height();
    return this.Height;
endfunction : get_height

task base_matrix::set_width(int Width_i);
    this.Width = Width;
endtask : set_width

task base_matrix::set_height(int Height_i);
    this.Height = Height_i;
endtask : set_height

function void base_matrix::create_matrix();
    // creating one-dimensional array
    R = new [Width];
    G = new [Width];
    B = new [Width];
    // creating two-dimensional array
    foreach( R[i] )
        R[i] = new [Height];
    foreach( G[i] )
        G[i] = new [Height];
    foreach( B[i] )
        B[i] = new [Height];
endfunction : create_matrix

task base_matrix::free_matrix();
    R.delete();
    G.delete();
    B.delete();
endtask : free_matrix

// function for getting current name
function string base_matrix::path2file(string format);
    cycle_s.itoa( cycle );  // converting cycle (int) to cycle_s (string)
    return  {
                path2folder,
                image_name,
                cycle_s,
                format
            };
endfunction : path2file

task base_matrix::load_matrix();
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
            $fscanf( fd, "%c%c%c", R[i][j], G[i][j], B[i][j] );

    $fclose( fd );
endtask : load_matrix

task base_matrix::save_matrix();
    fn = path2file( ".data" );

    fd = $fopen( fn, "wb" );

    if( !fd )
    begin
        $display( "file is not open!" );
        $stop;
    end
    
    for( int j = 0 ; j < Height ; j++ )
        for( int i = 0 ; i < Width ; i++ )
            $fwrite( fd, "%c%c%c", R[i][j], G[i][j], B[i][j] );

    $fflush( fd );
    $fclose( fd );

    $display( "next image loaded at time %t", $time );
    cycle_inc();
endtask : save_matrix

// task for setting image pixel value in RGB format
function void base_matrix::set_RGB(int x, int y, bit[23 : 0] pixel_rgb);
    { R[x][y] , G[x][y] , B[x][y] } = pixel_rgb;
endfunction : set_RGB

// task for setting image pixel value in RGB format with auto increment
function bit base_matrix::set_image_RGB(bit[23 : 0] pixel_rgb);
    bit eoi = '0;    // end of image

    p_c++;
    this.set_RGB( p_x, p_y, pixel_rgb );
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
endfunction : set_image_RGB

// task for getting image pixel value in RGB format
function bit [23 : 0] base_matrix::get_RGB(int x, int y);
    return { R[x][y] , G[x][y] , B[x][y] };
endfunction : get_RGB

// task for getting image pixel value in RGB format with auto increment
function bit base_matrix::get_image_RGB(ref bit [23 : 0] pixel_rgb);
    bit eoi = '0;    // end of image
    p_c++;
    pixel_rgb = this.get_RGB( p_x, p_y );
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
endfunction : get_image_RGB

function bit base_matrix::set_image_Bayer( bit [7 : 0] Bayer );
    bit eoi = '0;    // end of image
    bit [23 : 0] pixel_rgb = '0;

    case( { p_y[0] , p_x[0] } )
        2'b00   :   pixel_rgb[15 -: 8] = Bayer; // G
        2'b01   :   pixel_rgb[23 -: 8] = Bayer; // R
        2'b10   :   pixel_rgb[7  -: 8] = Bayer; // B
        2'b11   :   pixel_rgb[15 -: 8] = Bayer; // G
    endcase

    eoi = set_image_RGB( pixel_rgb );

    return eoi;
endfunction : set_image_Bayer

function bit base_matrix::get_image_Bayer(ref bit [7 : 0] Bayer);
    bit eoi = '0;    // end of image
    bit [23 : 0] pixel_rgb;
    bit p_x_lsb;
    bit p_y_lsb;

    p_x_lsb = p_x[0];
    p_y_lsb = p_y[0];

    eoi = get_image_RGB(pixel_rgb);

    case( { p_y_lsb , p_x_lsb } )
        2'b00   :   Bayer = pixel_rgb[15 -: 8]; // G
        2'b01   :   Bayer = pixel_rgb[23 -: 8]; // R
        2'b10   :   Bayer = pixel_rgb[7  -: 8]; // B
        2'b11   :   Bayer = pixel_rgb[15 -: 8]; // G
    endcase

    return eoi;
endfunction : get_image_Bayer

task base_matrix::copy_arrays(base_matrix oth_matrix);
    if( ( oth_matrix.Width == this.Width ) && ( oth_matrix.Height == this.Height ) )
    begin
        foreach(R[i,j])
        begin
            this.R[i][j] = oth_matrix.R[i][j];
            this.G[i][j] = oth_matrix.G[i][j];
            this.B[i][j] = oth_matrix.B[i][j];
        end
    end
    else
        $fatal("Other matrix has other dimentions!");
endtask : copy_arrays

task base_matrix::mix_arrays(base_matrix oth_matrix);
    if( ( oth_matrix.Width == this.Width ) && ( oth_matrix.Height == this.Height ) )
    begin
        foreach(R[i,j])
        begin
            this.R[i][j] = ( this.R[i][j] + oth_matrix.R[i][j] ) >> 1;
            this.G[i][j] = ( this.G[i][j] + oth_matrix.G[i][j] ) >> 1;
            this.B[i][j] = ( this.B[i][j] + oth_matrix.B[i][j] ) >> 1;
        end
    end
    else
        $fatal("Other matrix has other dimentions!");
endtask : mix_arrays

task base_matrix::find_and_save_gist();
    cycle_s.itoa( cycle );
    gist.find_gist( R, G, B );
    gist.save_gist( path2folder, image_name, cycle_s );
endtask : find_and_save_gist

task base_matrix::cycle_inc();
    this.cycle++;
endtask : cycle_inc

task base_matrix::reset_pos();
    p_x = 0;
    p_y = 0;
    p_c = 0;
endtask : reset_pos

task base_matrix::rgb2ycbcr();
    int Y_comp;
    int Cb_comp;
    int Cr_comp;

    foreach(R[i,j])
    begin
        Y_comp  = rgb2ycbcr_coefs[0]*R[i][j] + rgb2ycbcr_coefs[1]*G[i][j] + rgb2ycbcr_coefs[2]*B[i][j] + rgb2ycbcr_offs[0];
        Cb_comp = rgb2ycbcr_coefs[3]*R[i][j] + rgb2ycbcr_coefs[4]*G[i][j] + rgb2ycbcr_coefs[5]*B[i][j] + rgb2ycbcr_offs[1];
        Cr_comp = rgb2ycbcr_coefs[6]*R[i][j] + rgb2ycbcr_coefs[7]*G[i][j] + rgb2ycbcr_coefs[8]*B[i][j] + rgb2ycbcr_offs[2];

        R[i][j] = Y_comp;
        G[i][j] = Cb_comp;
        B[i][j] = Cr_comp;
    end
endtask : rgb2ycbcr

task base_matrix::ycbcr2rgb();
    int Y_comp;
    int Cb_comp;
    int Cr_comp;
    int R_comp;
    int G_comp;
    int B_comp;
    foreach(R[i,j])
    begin
        Y_comp  = R[i][j] + ycbcr2rgb_offs[0];
        Cb_comp = G[i][j] + ycbcr2rgb_offs[1];
        Cr_comp = B[i][j] + ycbcr2rgb_offs[2];

        R_comp = ycbcr2rgb_coefs[0]*Y_comp + ycbcr2rgb_coefs[1]*Cb_comp + ycbcr2rgb_coefs[2]*Cr_comp;
        G_comp = ycbcr2rgb_coefs[3]*Y_comp + ycbcr2rgb_coefs[4]*Cb_comp + ycbcr2rgb_coefs[5]*Cr_comp;
        B_comp = ycbcr2rgb_coefs[6]*Y_comp + ycbcr2rgb_coefs[7]*Cb_comp + ycbcr2rgb_coefs[8]*Cr_comp;

        R[i][j] = (R_comp < 0) ? 0 : ( (R_comp > 255) ? 255 : R_comp );
        G[i][j] = (G_comp < 0) ? 0 : ( (G_comp > 255) ? 255 : G_comp );
        B[i][j] = (B_comp < 0) ? 0 : ( (B_comp > 255) ? 255 : B_comp );
    end
endtask : ycbcr2rgb

task base_matrix::clnpix();
    foreach(R[i,j])
    begin
        R[i][j] = '0;
        G[i][j] = '0;
        B[i][j] = '0;
    end
endtask : clnpix

function base_matrix base_matrix::create(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = ".data", string out_format_i[] = {".data"});
    base_matrix ret_matrix = new(Width_i, Height_i, path2folder_i, image_name_i, in_format_i, out_format_i);
    return ret_matrix;
endfunction : create

`endif // BASE_MATRIX__SV
