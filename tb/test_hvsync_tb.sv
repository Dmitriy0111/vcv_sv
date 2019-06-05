/*
*  File            :   test_hvsync_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   03.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for test_hvsync
*  Copyright(c)    :   2019 Vlasov D.V
*/

`include "img_matrix.sv"

module test_hvsync_tb;

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

    wrapper_test_hvsync
    wrapper_test_hvsync_0
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
        right   = 1'b0;
    end

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
            @(posedge wrapper_test_hvsync_0.clk_div);
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

endmodule : test_hvsync_tb
