/*
*  File            :   racing_game_v3_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for racing_game wrapper for 8bitworkshop
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

module racing_game_v3_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import work_pkg::*;

    parameter           T = 10,
                        rst_delay = 7,
                        rep_c = 10,
                        use_matrix = "img_matrix";

    bit     [0 : 0]     clk;
    bit     [0 : 0]     reset; 
    logic   [0 : 0]     hsync;
    logic   [0 : 0]     vsync; 
    logic   [2 : 0]     rgb;
    logic   [0 : 0]     left;
    logic   [0 : 0]     right;
    logic   [3 : 0]     keys;

    int                 rep_cycles = 0;

    wrapper_racing_game_v3
    wrapper_racing_game_v3_0
    (
        .clk        ( clk       ), 
        .reset      ( reset     ), 
        .keys       ( keys      ),
        .hsync      ( hsync     ), 
        .vsync      ( vsync     ), 
        .rgb        ( rgb       )
    );

    base_matrix matrix_out;

    assign keys = '0 | { right , left };

    initial
    begin
        case(use_matrix)
            "img_matrix":
            begin
                img_matrix l_matrix_out = new(800, 525, "../output_images/", "out_image_");
                matrix_out = l_matrix_out;
            end
            "ppm_matrix":
            begin
                ppm_matrix l_matrix_out = new(800, 525, "../output_images/", "out_image_");
                matrix_out = l_matrix_out;
            end
        endcase
    end

    initial
    begin
        left    = 1'b0;
        right   = 1'b1;
    end
    initial
        $readmemb( "../rtl/wrapper_for_8bitworkshop/fpga-examples/car.hex", wrapper_racing_game_v3_0.racing_game_top_v3_0.car.bitarray );

    // generate clock
    initial 
    begin
        forever 
            #( T / 2 ) clk = ~ clk;
    end
    // generate reset
    initial 
    begin 
        reset = '1;
        repeat(rst_delay) @(posedge clk);
        reset = '0;
    end
    // working with output matrix
    initial
    begin
        forever
        begin
            @(posedge wrapper_racing_game_v3_0.clk_div);
            if( !reset )
            begin
                if( matrix_out.set_image_RGB( { { 8 { rgb[2] } } , { 8 { rgb[1] } } , { 8 { rgb[0] } } } ) )
                begin
                    matrix_out.save_matrix();
                    rep_cycles ++;
                    if( rep_cycles == rep_c )
                        $stop;
                end
            end
        end
    end

endmodule : racing_game_v3_tb
