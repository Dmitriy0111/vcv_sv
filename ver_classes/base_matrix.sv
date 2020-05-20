/*
*  File            :   base_matrix.sv
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is base matrix class
*  Copyright(c)    :   2019-2020 Vlasov D.V
*/

`ifndef BASE_MATRIX__SV
`define BASE_MATRIX__SV

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
    int                 p_x;
    int                 p_y;
    int                 p_c;
    // cycle variable
    int                 cycle;          // Current cycle variable
    bit                 stop_v = '1;    // if '1 then $stop executed
    // variable's for working with files
    int                 fd;             // file descriptor
    string              path2folder;    // path to folder with storing/loading images
    string              image_name;     // sub-image name
    string              cycle_s = "";   // current cycle variable (string)
    string              fn;             // image full name
    string              out_format[$];
    string              in_format;

    extern         function                 new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "", string out_format_i[]={""});

    extern virtual task                     create_matrix();
    extern virtual task                     free_matrix();

    extern virtual function string          path2file(string format);

    extern virtual task                     load_matrix();
    extern virtual task                     save_matrix();

    extern virtual function void            set_RGB(int x, int y, bit [23 : 0] pixel_rgb);
    extern virtual function bit             set_image_RGB(bit [23 : 0] pixel_rgb);

    extern virtual function bit [23 : 0]    get_RGB(int x, int y);
    extern virtual function bit             get_image_RGB(ref bit [23 : 0] pixel_rgb);

    extern virtual function bit             set_image_Bayer(bit [7 : 0] Bayer);
    extern virtual function bit             get_image_Bayer(ref bit [7 : 0] Bayer);

    extern virtual task                     find_and_save_gist();

    extern virtual task                     cycle_inc();

endclass : base_matrix

// class constructor
function base_matrix::new(int Width_i, int Height_i, string path2folder_i, string image_name_i, string in_format_i = "", string out_format_i[]={""});
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
    
endfunction : new

task base_matrix::create_matrix();
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
endtask : create_matrix

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
endtask : load_matrix

task base_matrix::save_matrix();
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
        $display("Image received at %t ns", $time);
    end

    return eoi;
endfunction : set_image_RGB

function bit base_matrix::set_image_Bayer(bit [7 : 0] Bayer);
    bit eoi = '0;    // end of image
    bit [23 : 0] pixel_rgb = '0;

    case( { p_y[0] , p_x[0] } )
        2'b00   :   pixel_rgb[16 -: 8] = Bayer; // G
        2'b01   :   pixel_rgb[23 -: 8] = Bayer; // R
        2'b10   :   pixel_rgb[7  -: 8] = Bayer; // B
        2'b11   :   pixel_rgb[16 -: 8] = Bayer; // G
    endcase

    eoi = set_image_RGB(pixel_rgb);

    return eoi;
endfunction : set_image_Bayer

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

function bit base_matrix::get_image_Bayer(ref bit [7 : 0] Bayer);
    bit eoi = '0;    // end of image
    bit [23 : 0] pixel_rgb;
    bit p_x_lsb;
    bit p_y_lsb;

    p_x_lsb = p_x[0];
    p_y_lsb = p_y[0];

    eoi = get_image_RGB(pixel_rgb);

    case( { p_y_lsb , p_x_lsb } )
        2'b00   :   Bayer = pixel_rgb[16 -: 8]; // G
        2'b01   :   Bayer = pixel_rgb[23 -: 8]; // R
        2'b10   :   Bayer = pixel_rgb[7  -: 8]; // B
        2'b11   :   Bayer = pixel_rgb[16 -: 8]; // G
    endcase

    return eoi;
endfunction : get_image_Bayer

task base_matrix::find_and_save_gist();
    cycle_s.itoa( cycle );
    gist.find_gist(R,G,B);
    gist.save_gist(path2folder,image_name,cycle_s);
endtask : find_and_save_gist

// increment cycle variable
task base_matrix::cycle_inc();
    this.cycle++;
endtask : cycle_inc

`endif // BASE_MATRIX__SV
