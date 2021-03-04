/*
*  File            :   test_matrix_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   12.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for ppm_matrix
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

module test_matrix_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import vcv_sv_pkg::*;

    parameter           T = 10,
                        rst_delay = 7,
                        rep_c = 100;
                        
    parameter           width_i = 1024,
                        height_i = 768,
                        path2folder_i = "../input_images/",
                        matrix_name_i = "in_image_",
                        use_matrix_i = "base_matrix";

    parameter           width_o = 1024,
                        height_o = 768,
                        path2folder_o = "../output_images/",
                        matrix_name_o = "out_image_",
                        use_matrix_o = "img_matrix";

    bit     [0  : 0]    clk;        // clock
    bit     [23 : 0]    rgb;

    int                 c_time;
    int                 old_time;

    int                 save_time = 0;
    int                 load_time = 0;
    
    int                 rep_cycles = 0;

    base_matrix matrix_in;

    base_matrix matrix_out;

    initial
    begin
        case( use_matrix_i )
            "img_matrix"    : matrix_in = img_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, ".jpg", {".jpg"} );
            "ppm_matrix"    : matrix_in = ppm_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, "P3", {"P3"} );
            "pat_matrix"    : matrix_in = pat_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, "Archimed", );
            "base_matrix"   : matrix_in = base_matrix::create( width_i, height_i, path2folder_i, matrix_name_i, ".data", {".data"} );
            default         : $fatal();
        endcase
        matrix_in.load_matrix();
    end

    initial
    begin
        case( use_matrix_o )
            "img_matrix"    : matrix_out = img_matrix ::create( width_o, height_o, path2folder_o, matrix_name_o, ".jpg", {".jpg"} );
            "ppm_matrix"    : matrix_out = ppm_matrix ::create( width_o, height_o, path2folder_o, matrix_name_o, "P3", {"P3"} );
            "base_matrix"   : matrix_out = base_matrix::create( width_o, height_o, path2folder_o, matrix_name_o, ".data", {".data"} );
            default         : $fatal();
        endcase
    end
    // generate clock
    initial 
    begin
        forever 
            #( T / 2 ) clk = ~ clk;
    end
    // working with output matrix
    initial
    begin
        forever
        begin
            @(posedge clk);
            if( matrix_in.get_image_RGB( rgb ) )
            begin
                old_time = get_current_time();
                matrix_in.load_matrix();
                c_time = get_current_time();
                load_time += c_time-old_time;
                matrix_in.find_and_save_gist();
                $display( "Load time %d", c_time-old_time );
            end
            if( matrix_out.set_image_RGB( ~rgb ) )
            begin
                matrix_out.find_and_save_gist();
                old_time = get_current_time();
                matrix_out.save_matrix();
                c_time = get_current_time();
                save_time += c_time-old_time;
                $display( "Save time %d", c_time-old_time );
                rep_cycles++;
                if( rep_cycles == rep_c )
                begin
                    $display( "Total save time = %d, total load time = %d", load_time, save_time );
                    $display( "Save time = %d, load time = %d", load_time/rep_c, save_time/rep_c );
                    $stop;
                end
            end
        end
    end

endmodule : test_matrix_tb
