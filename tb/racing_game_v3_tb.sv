/*
*  File            :   racing_game_v3_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   01.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for wrapper_for_8bitworkshop_tb
*  Copyright(c)    :   2019 Vlasov D.V
*/

`include "img_matrix.sv"

module racing_game_v3_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import img_matrix_pkg::*;

    parameter           T = 10,
                        rst_delay = 7,
                        rep_c = 40;

    // creating output matrix
    img_matrix img_matrix_out = new (800,525,"../output_images/","out_image_",'1);

    bit     [0 : 0]     clk;
    bit     [0 : 0]     reset; 
    logic   [0 : 0]     hsync;
    logic   [0 : 0]     vsync; 
    logic   [2 : 0]     rgb;
    logic   [0 : 0]     left;
    logic   [0 : 0]     right;
    logic   [3 : 0]     keys;
    integer             rep_cycles = 0;

    assign keys = '0 | {right,left};

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

    initial
    begin
        
    end
    initial
    begin
        left    = 1'b0;
        right   = 1'b1;
    end
    initial
        $readmemb("../rtl/wrapper_for_8bitworkshop/fpga-examples/car.hex",wrapper_racing_game_v3_0.racing_game_top_v3_0.car.bitarray);

    // generate clock
    initial 
    begin
        forever 
            #(T/2) clk = ~ clk;
    end
    // generate reset, enable, foreground and background
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
                if( img_matrix_out.set_image_RGB( { { 8 { rgb[2] } } , { 8 { rgb[1] } } , { 8 { rgb[0] } } } ) )
                begin
                    img_matrix_out.load_img_to_mem();
                    rep_cycles ++;
                    if( rep_cycles == rep_c )
                        $stop;
                end
            end
        end
    end

endmodule : racing_game_v3_tb
