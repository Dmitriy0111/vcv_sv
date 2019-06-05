/*
*  File            :   MinesweeperFPGA_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   03.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for test_hvsync
*  Copyright(c)    :   2019 Vlasov D.V
*/

`include "img_matrix.sv"

module MinesweeperFPGA_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import img_matrix_pkg::*;

    parameter           T = 40,             // 25 MHz
                        rst_delay = 7,
                        rep_c = 40;

    localparam          U_key   = 8'h1D,
                        D_key   = 8'h1B,
                        L_key   = 8'h1C,
                        R_key   = 8'h23,
                        N_key   = 8'h31,
                        Y_key   = 8'h35,
                        Sp_key  = 8'h29,
                        En_key  = 8'h5A,
                        Esc_key = 8'h76;

    // creating output matrix
    img_matrix img_matrix_out = new (800,528,"../output_images/","out_image_",'1);

    bit     [0 : 0]     clk;
    bit     [0 : 0]     reset; 
    bit     [0 : 0]     ps2_clk;
    bit     [0 : 0]     ps2_data; 
    logic   [0 : 0]     h_vga;
    logic   [0 : 0]     v_vga;
    logic   [2 : 0]     rgb;
    logic   [8 : 1]     leds;
    integer             rep_cycles = 0;
    bit     [0 : 0]     cycle_bit;

    ctrl_main_block 
    ctrl_main_block_0
    (
        // system signals
        .reset      ( reset     ),  // SW(0)
        .clk        ( clk       ),  // Pixel clk - DCM should generate 25 MHz freq;  
        // ps/2 signals
        .ps2_clk    ( ps2_clk   ),  // PS/2 CLOCK
        .ps2_data   ( ps2_data  ),  // PS/2 SERIAL DATA
        // vga output signals
        .h_vga      ( h_vga     ),  // horizontal
        .v_vga      ( v_vga     ),  // vertical
        .rgb        ( rgb       ),  // (R-G-B)
        // test leds signals
        .leds       ( leds      )
    );

    initial
    begin
        ps2_data = '1;
        ps2_clk = '1;
        @(posedge cycle_bit);
        button_toggle(Sp_key);
        @(posedge cycle_bit);
        button_toggle(D_key);
        @(posedge cycle_bit);
        button_toggle(En_key);
        @(posedge cycle_bit);
        $stop;
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
        reset = '0;
        repeat(rst_delay) @(posedge clk);
        reset = '1;
    end
    // working with output matrix
    initial
    begin
        forever
        begin
            cycle_bit = '0;
            @(posedge clk);
            if( reset )
            begin
                if( img_matrix_out.set_image_RGB( { { 8 { rgb[2] } } , { 8 { rgb[1] } } , { 8 { rgb[0] } } } ) )
                begin
                    img_matrix_out.load_img_to_mem();
                    rep_cycles ++;
                    cycle_bit = '1;
                    if( rep_cycles == rep_c )
                        $stop;
                end
            end
        end
    end

    task keyboard_send(logic [7 : 0] data, integer period);
        bit odd_parity;
        odd_parity = ~^data;
        // generate start
        ps2_data = '0;
        repeat(period/2) @(posedge clk);
        ps2_clk = '0;
        repeat(period/2) @(posedge clk);
        ps2_clk = '1;
        // send byte
        repeat(8)
        begin
            ps2_data = data[0];
            repeat(period/2) @(posedge clk);
            ps2_clk = '0;
            repeat(period/2) @(posedge clk);
            ps2_clk = '1;
            data = data >> 1;
        end
        // generate parity
        ps2_data = odd_parity;
        repeat(period/2) @(posedge clk);
        ps2_clk = '0;
        repeat(period/2) @(posedge clk);
        ps2_clk = '1;
        // generate stop
        ps2_data = '1;
        repeat(period/2) @(posedge clk);
        ps2_clk = '0;
        repeat(period/2) @(posedge clk);
        ps2_clk = '1;
    endtask : keyboard_send

    task button_toggle(logic [7 : 0] data);
        keyboard_send(data,1500);
        repeat(10000) @(posedge clk);
        keyboard_send(8'hF0,1500);
        repeat(10000) @(posedge clk);
    endtask : button_toggle

endmodule : MinesweeperFPGA_tb
