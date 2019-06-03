/*
*  File            :   img_matrix.sv
*  Autor           :   Vlasov D.V
*  Data            :   01.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is test matrix file for testing video ip cores
*  Copyright(c)    :   2019 Vlasov D.V
*/

`timescale 1ns/100ps

package img_matrix_pkg;

    // Make C function visible to verilog code
    // import "DPI-C" context function int test(output int unsigned R,output  int unsigned G,output int unsigned B);
    import "DPI-C" context function int open_image(input string path, input int width, input int height);
    import "DPI-C" context function int load_pix(input int pix_pos,output int unsigned R,output  int unsigned G,output int unsigned B);
    import "DPI-C" context function int free_image();
    import "DPI-C" context function store_pix(input int pix_pos,input int R,input int G,input int B);
    import "DPI-C" context function save_image(input string path, input int width, input int height);
    import "DPI-C" context function create_image( input int width, input int height);
    
    class img_matrix;
            
        //Matrix Height and Width
        integer             Height;         // Image height
        integer             Width;          // Image width
        integer             Resolution;     // Image resolution
        //Bayer pixel index
        integer             b_x;            // Bayer pixel x position
        integer             b_y;            // Bayer pixel y position
        integer             b_c;            // Bayer counter
        //RGB pixel index
        integer             rgb_x;          // RGB pixel x position
        integer             rgb_y;          // RGB pixel y position
        integer             rgb_c;          // RGB counter
        //Matrix RGB
        bit     [7 : 0]     R[][];          // R pixel array
        bit     [7 : 0]     G[][];          // G pixel array
        bit     [7 : 0]     B[][];          // B pixel array
        //cycle variable
        integer             cycle;          // Current cycle variable
        bit                 stop_v = '1;    // if '1 then $stop executed
        
        //variable's for working with images
        string              path2folder;    // path    
        string              image_name;     // sub-image name
        string              cycle_s = "";   // current cycle variable (string)
        string              common_name;    // current image name  
        // function to returning current image name
        function string path2file ();

            cycle_s.itoa(cycle);    // converting cycle (integer) to cycle_s (string)
            common_name =   {
                                path2folder,
                                image_name,
                                cycle_s,
                                ".jpg"
                            };
            return common_name;
        
        endfunction : path2file
        
        // class constructor
        function new( integer Width_i, integer Height_i, string path2folder_i, string image_name_i, bit load_img = '0, bit stop_v_i = '0 );
            // creating a one-dimensional array
            R = new [Width_i];
            G = new [Width_i];
            B = new [Width_i];
            // creating a two-dimensional array
            foreach( R[i] )
                R[i] = new [Height_i];
            foreach( G[i] )
                G[i] = new [Height_i];
            foreach( B[i] )
                B[i] = new [Height_i];
            Height = Height_i;
            Width  = Width_i; 
            Resolution = Width * Height;
            // reset bayer 
            b_x = '0;
            b_y = '0;
            b_c = '0;
            // reset rgb
            rgb_x = '0;
            rgb_y = '0;
            rgb_c = '0;
            // reset cycle
            cycle = '0;
            stop_v = stop_v_i;
            // init help variables
            path2folder = path2folder_i;
            image_name = image_name_i;
            common_name = path2file;
            // load image
            if( !load_img )
                load_img_from_txt();
            
        endfunction : new

        function recreate( integer Width_i, integer Height_i, string path2folder_i, string image_name_i, bit load_img = '0, bit stop_v_i = '0 );

            R.delete();
            G.delete();
            B.delete();

            // creating a one-dimensional array
            R = new [Width_i];
            G = new [Width_i];
            B = new [Width_i];
            // creating a two-dimensional array
            foreach( R[i] )
                R[i] = new [Height_i];
            foreach( G[i] )
                G[i] = new [Height_i];
            foreach( B[i] )
                B[i] = new [Height_i];
            Height = Height_i;
            Width  = Width_i; 
            Resolution = Width * Height;
            // reset bayer 
            b_x = '0;
            b_y = '0;
            b_c = '0;
            // reset rgb
            rgb_x = '0;
            rgb_y = '0;
            rgb_c = '0;
            // reset cycle
            cycle = '0;
            stop_v = stop_v_i;
            // init help variables
            path2folder = path2folder_i;
            image_name = image_name_i;
            common_name = path2file;
            // load image
            if( !load_img )
                load_img_from_txt();

        endfunction : recreate
        //getting pixel in Bayer format
        /*
        pixel format
        G R G R G * * R G R G R
        B G B G B * * G B G B G
        * * * * * * * * * * * *
        G R G R G * * R G R G R
        B G B G B * * G B G B G
        */
        function bit[7 : 0] get_Bayer();

            bit[7 : 0] ret_bayer;
            
            if( b_x % 2 == 0 )
            begin
                if( b_y % 2 == 0 )
                    ret_bayer = G[b_x][b_y];
                else
                    ret_bayer = B[b_x][b_y];
            end
            else
            begin
                if( b_y % 2 == 0 )
                    ret_bayer = R[b_x][b_y];
                else
                    ret_bayer = G[b_x][b_y];
            end
            
            b_c++;
            b_x++;
            
            if( b_x == Width )
            begin
                b_x = 0;
                b_y++;
            end
            
            if( b_c == Resolution )
            begin
                b_x = '0;
                b_y = '0;
                b_c = '0; 
                load_img_from_txt();
                $display("next image loaded");
                if( stop_v )
                    $stop;
            end
            
            return ret_bayer;
        endfunction : get_Bayer
        /*
            task for reset bayer variables
        */
        task reset_Bayer();
            $display("bayer pixel position is clear");
            b_x = '0;
            b_y = '0;
            b_c = '0; 
        endtask : reset_Bayer
        /*
            task for getting image pixel value in RGB format
        */
        function bit[23 : 0] get_RGB( integer x, integer y );
            return { R[x][y] , G[x][y] , B[x][y] };
        endfunction : get_RGB
        /*
            task for getting image pixel value in RGB format with auto increment
        */
        function bit[23 : 0] get_image_RGB();
            bit[23 : 0] ret_RGB;
            rgb_c++;
            ret_RGB = this.get_RGB(rgb_x,rgb_y);
            rgb_x++;
            if( rgb_x == this.Width )
            begin
                rgb_x = '0;
                rgb_y++;
            end
            if( rgb_c == this.Resolution )
            begin
                rgb_x = '0;
                rgb_y = '0;
                rgb_c = '0;
                load_img_from_txt();
            end
            return ret_RGB;
        endfunction : get_image_RGB
        /*
            task for setting image pixel value in RGB format
        */
        function void set_RGB( integer x, integer y, bit[23 : 0] pixel_rgb );
            { R[x][y] , G[x][y] , B[x][y] } = pixel_rgb;
        endfunction : set_RGB
        /*
            task for setting image pixel value in RGB format with auto increment
        */
        function bit set_image_RGB( bit[23 : 0] pixel_rgb );
            bit eoi = '0;    //end of image
            this.set_RGB( rgb_x , rgb_y , pixel_rgb );

            if( rgb_c == this.Resolution )
            begin
                eoi = '1;
                rgb_x = '0;
                rgb_y = '0;
                rgb_c = '0;
            end
            rgb_c++;
            
            rgb_x++;
            if( rgb_x == this.Width )
            begin
                rgb_x = '0;
                rgb_y++;
            end

            return eoi;
        endfunction : set_image_RGB
        /*
            task for loading image from file in matrix
        */
        task load_img_from_txt();
            integer read_value;
            integer i,j;
            int     null_detect;
            do
            begin
                null_detect = open_image( path2file, Width, Height );
                if( null_detect != 1 )
                    cycle = '0;
            end
            while( null_detect != 1 );

            for( i = 0 ; i < Width ; i++ )
                for( j = 0 ; j < Height ;j++ )
                    load_pix( (i + j * Width ) * 3 , R[i][j] , G[i][j] , B[i][j] );
            free_image();
            cycle++;        
        endtask : load_img_from_txt
        /*
            task for loading image from matrix in file
        */
        task load_img_to_txt();
            integer read_value;
            integer i,j;
            create_image( Width , Height );
            for( i = 0 ; i < Width ;i++ )
                for( j = 0 ; j < Height ; j++ )
                    store_pix( ( i + j * Width ) * 3 , R[i][j] , G[i][j] , B[i][j] );
            save_image( path2file , Width , Height );
            if( stop_v )
                $stop;
            cycle++;   
        endtask : load_img_to_txt

        task clear_res();
            R.delete();
            G.delete();
            B.delete();
        endtask : clear_res
        
    endclass : img_matrix

endpackage: img_matrix_pkg
