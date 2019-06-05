/*
*  File            :   threshold_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   05.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for threshold
*  Copyright(c)    :   2019 Vlasov D.V
*/

`include "img_matrix.sv"

module threshold_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import img_matrix_pkg::*;

    parameter           T = 10,
                        rst_delay = 7,
                        rep_c = 40;

    integer             rep_cycles = 0;

    // creating input matrix
    img_matrix img_matrix_in = new (800,600,"../input_images/","in_image_",'0);
    // creating output matrix
    img_matrix img_matrix_out = new (800,600,"../output_images/","out_image_",'1);

    bit     [0  : 0]    clk;
    bit     [0  : 0]    resetn;
    //
    logic   [23 : 0]    d_in;
    logic   [0  : 0]    d_in_vld;
    logic   [23 : 0]    d_out;
    logic   [0  : 0]    d_out_vld;
    //
    bit     [15 : 0]    input_res_x;
    bit     [15 : 0]    input_res_y;
    bit     [0  : 0]    threshold_set;
    bit     [23 : 0]    threshold_v;
    bit     [2  : 0]    threshold_c;
    bit     [1  : 0]    threshold_a;

    logic   [7  : 0]    R;
    logic   [7  : 0]    G;
    logic   [7  : 0]    B;
    
    logic   [7  : 0]    R_in;
    logic   [7  : 0]    G_in;
    logic   [7  : 0]    B_in;
    logic   [7  : 0]    R_out;
    logic   [7  : 0]    G_out;
    logic   [7  : 0]    B_out;

    assign R_in  = d_in[23 -: 8];
    assign G_in  = d_in[15 -: 8];
    assign B_in  = d_in[7  -: 8];

    assign R_out = d_out[23 -: 8];
    assign G_out = d_out[15 -: 8];
    assign B_out = d_out[7  -: 8];

    threshold 
    threshold_0
    (
        // clock and reset
        .clk            ( clk           ),
        .resetn         ( resetn        ),
        //
        .d_in           ( d_in          ),
        .d_in_vld       ( d_in_vld      ),
        .d_out          ( d_out         ),
        .d_out_vld      ( d_out_vld     ),
        //
        .input_res_x    ( input_res_x   ),
        .input_res_y    ( input_res_y   ),
        .threshold_set  ( threshold_set ),
        .threshold_v    ( threshold_v   ),
        .threshold_c    ( threshold_c   ),
        .threshold_a    ( threshold_a   )
    );

    // generate clock
    initial 
    begin
        forever 
            #(T/2) clk = ~ clk;
    end
    // generate reset, enable, foreground and background
    initial 
    begin 
        resetn = '0;
        repeat(rst_delay) @(posedge clk);
        resetn = '1;
    end
    // generate d_in
    initial
    begin
        input_res_x = 800;
        input_res_y = 600;
        @(posedge resetn);
        repeat(4)
        begin
            threshold_set = '1;
            threshold_c = 3'b111;
            threshold_v = $random;
            @(posedge clk);
            threshold_a ++;
        end
        threshold_set = '0;
        threshold_c = '0;
        @(posedge clk);
        forever
        begin
            img_matrix_in.get_image_RGB(d_in);
            d_in_vld = '1;
            @(posedge clk);
        end
    end
    // working with output matrix
    initial
    begin
        forever
        begin
            if( resetn )
            begin
                if( d_out_vld )
                begin
                    if( img_matrix_out.set_image_RGB( d_out ) )
                    begin
                        img_matrix_out.load_img_to_txt();
                        img_matrix_out.load_img_to_mem();
                        rep_cycles ++;
                        if( rep_cycles == rep_c )
                            $stop;
                    end
                end
            end
            @(posedge clk);
        end
    end

endmodule : threshold_tb
