/*
*  File            :   dsc_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   01.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for DebugScreenCore ( https://github.com/Dmitriy0111/DebugScreenCore )
*  Copyright(c)    :   2019 Vlasov D.V
*/

`include "img_matrix.sv"

module dsc_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import img_matrix_pkg::*;

    parameter           T = 10,
                        rst_delay = 7;

    localparam          cpu = "nanoFOX",
                        sub_path = "../rtl/DebugScreenCore/";

    bit     [0  : 0]    clk;        // clock
    bit     [0  : 0]    resetn;     // reset
    bit     [0  : 0]    en;         // enable input
    logic   [0  : 0]    hsync;      // hsync output
    logic   [0  : 0]    vsync;      // vsync output
    bit     [11 : 0]    bgColor;    // background color
    bit     [11 : 0]    fgColor;    // foreground color
    logic   [31 : 0]    regData;    // register data input from cpu
    logic   [4  : 0]    regAddr;    // register addr output to cpu
    logic   [3  : 0]    R;          // R-color
    logic   [3  : 0]    G;          // G-color
    logic   [3  : 0]    B;          // B-color

    bit     [31 : 0]    test_mem    [31 : 0];

    // creating output matrix
    img_matrix img_matrix_out = new (800,525,"../output_images/","out_image_",'1);

    assign regData = test_mem[regAddr];
    // creating one DebugScreenCore
    vga_ds_top
    #(
        .cpu        ( cpu           ),
        .sub_path   ( sub_path      )
    )
    vga_ds_top_0
    (
        .clk        ( clk           ),  // clock
        .resetn     ( resetn        ),  // reset
        .en         ( en            ),  // enable input
        .hsync      ( hsync         ),  // hsync output
        .vsync      ( vsync         ),  // vsync output
        .bgColor    ( bgColor       ),  // background color
        .fgColor    ( fgColor       ),  // foreground color
        .regData    ( regData       ),  // register data input from cpu
        .regAddr    ( regAddr       ),  // register addr output to cpu
        .R          ( R             ),  // R-color
        .G          ( G             ),  // G-color
        .B          ( B             )   // B-color
    );
    // init test memory
    initial
    begin
        foreach( test_mem[i] )
            test_mem[i] = $random;
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
        bgColor = 12'hFF0;
        fgColor = 12'h00F;
        en = '1;
        repeat(rst_delay) @(posedge clk);
        resetn = '1;
    end
    // working with output matrix
    initial
    begin
        forever
        begin
            @(posedge clk);
            if( resetn )
            begin
                if( img_matrix_out.set_image_RGB({R,R,G,G,B,B}) )
                    img_matrix_out.load_img_to_mem();
            end
        end
    end

endmodule : dsc_tb
