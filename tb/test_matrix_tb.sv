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

    import work_pkg::*;

    parameter           T = 10,
                        rst_delay = 7,
                        rep_c = 100,
                        use_matrix = "ppm_matrix";

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
        case( use_matrix )
            "img_matrix":
            begin
                img_matrix l_matrix_in  = new( 1024, 768, "../input_images/", "in_image_", ".jpg", {".jpg"} );
                img_matrix l_matrix_out = new( 1024, 768, "../output_images/", "out_image_", ".jpg", {".jpg"} );
                matrix_in = l_matrix_in;
                matrix_out = l_matrix_out;
            end
            "ppm_matrix":
            begin
                ppm_matrix l_matrix_in  = new( 1024, 768, "../../input_images/", "in_image_", "P3", {"P3"} );
                ppm_matrix l_matrix_out = new( 1024, 768, "../../output_images/", "out_image_", "P3", {"P3"} );
                matrix_in = l_matrix_in;
                matrix_out = l_matrix_out;
            end
        endcase
        matrix_in.load_matrix();
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
            if( matrix_out.set_image_RGB(~rgb) )
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
