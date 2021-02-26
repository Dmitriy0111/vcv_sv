/*
*  File            :   dsc_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for DebugScreenCore ( https://github.com/Dmitriy0111/DebugScreenCore )
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

module dsc_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import work_pkg::*;

    parameter           T = 10,
                        rst_delay = 7,
                        rep_c = 7,
                        sub_path = "../rtl/DebugScreenCore/",
                        use_matrix = "img_matrix";

    bit     [0  : 0]    clk;        // clock
    bit     [0  : 0]    resetn;     // reset
    bit     [0  : 0]    en;         // enable input
    logic   [0  : 0]    hsync;      // hsync output
    logic   [0  : 0]    vsync;      // vsync output
    logic   [11 : 0]    bgColor;    // background color
    logic   [11 : 0]    fgColor;    // foreground color
    logic   [31 : 0]    regData;    // register data input from cpu
    logic   [4  : 0]    regAddr;    // register addr output to cpu
    logic   [3  : 0]    R;          // R-color
    logic   [3  : 0]    G;          // G-color
    logic   [3  : 0]    B;          // B-color

    int                 repeat_c = 0;

    logic   [31 : 0]    test_mem [31 : 0];       

    base_matrix matrix_out;

    // creating one DebugScreenCore unit
    vga_ds_top
    #(
        .sub_path   ( sub_path      )
    )
    vga_ds_top_0
    (
        .clk        ( clk           ),  // clock
        .resetn     ( resetn        ),  // reset
        .en         ( en            ),  // enable
        .hsync      ( hsync         ),  // hsync output
        .vsync      ( vsync         ),  // vsync output
        .bgColor    ( bgColor       ),  
        .fgColor    ( fgColor       ),  
        .regData    ( regData       ),  
        .regAddr    ( regAddr       ),  
        .R          ( R             ),  // R-color
        .G          ( G             ),  // G-color
        .B          ( B             )   // B-color
    );

    assign bgColor = 12'h00F;
    assign fgColor = 12'hFF0;
    assign regData = test_mem[regAddr];
    // generate clock
    initial 
    begin
        forever 
            #( T / 2 ) clk = ~ clk;
    end
    // generate reset, enable, foreground and background
    initial 
    begin 
        repeat(rst_delay) @(posedge clk);
        resetn = '1;
    end
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
    // working with output matrix
    initial
    begin
        en = '1;
        foreach( test_mem[i] )
            test_mem[i] = $random();
        forever
        begin
            @(posedge clk);
            if( resetn )
                if( matrix_out.set_image_RGB( { { 2 { R } } , { 2 { G } } , { 2 { B } } } ) )
                begin
                    matrix_out.save_matrix();
                    repeat_c++;
                    if( repeat_c == rep_c )
                        $stop;
                end
        end
    end

endmodule : dsc_tb
