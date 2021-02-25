/*
*  File            :   MinesweeperFPGA_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for MinesweeperFPGA with ppm matrix file
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

module MinesweeperFPGA_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import work_pkg::*;
    import keyboard_pkg::*;

    parameter           T = 40,             // 25 MHz
                        rst_delay = 7,
                        use_matrix = "img_matrix";

    localparam          U_key   = 8'h1D,
                        D_key   = 8'h1B,
                        L_key   = 8'h1C,
                        R_key   = 8'h23,
                        N_key   = 8'h31,
                        Y_key   = 8'h35,
                        Sp_key  = 8'h29,
                        En_key  = 8'h5A,
                        Esc_key = 8'h76;

    bit     [0 : 0]     clk;
    bit     [0 : 0]     reset; 
    logic   [0 : 0]     h_vga;
    logic   [0 : 0]     v_vga;
    logic   [2 : 0]     rgb;
    logic   [7 : 0]     leds;

    bit     [0 : 0]     cycle_bit;

    int                 c_time;
    int                 old_time;

    keyboard_if         kb_if( clk, reset );

    keyboard_c          kb_c = new( kb_if, 1500 );

    ctrl_main_block 
    ctrl_main_block_0
    (
        // system signals
        .reset      ( reset             ),  // reset
        .clk        ( clk               ),  // clock  
        // ps/2 signals
        .ps2_clk    ( kb_if.ps2_clk     ),  // PS/2 clock
        .ps2_data   ( kb_if.ps2_data    ),  // PS/2 serial data
        // vga output signals
        .h_vga      ( h_vga             ),  // vga horizontal sync
        .v_vga      ( v_vga             ),  // vga vertical sync
        .rgb        ( rgb               ),  // vga RGB components
        // test leds signals
        .leds       ( leds              )   // leds
    );

    base_matrix matrix_out;

    initial
    begin
        case(use_matrix)
            "img_matrix":   matrix_out = img_matrix::create( 800, 528, "../output_images/", "out_image_");
            "ppm_matrix":   matrix_out = ppm_matrix::create( 800, 528, "../output_images/", "out_image_");
        endcase
    end

    initial
    begin
        kb_c.reset_signals();
        @(posedge cycle_bit);
        repeat( $urandom_range(0,200) ) @(posedge clk);
        kb_c.key_toggle( Sp_key );
        @(posedge cycle_bit);
        kb_c.key_toggle( D_key  );
        @(posedge cycle_bit);
        kb_c.key_toggle( En_key );
        @(posedge cycle_bit);
        $stop;
    end
    // generate clock
    initial 
    begin
        forever 
            #( T / 2 ) clk = ~ clk;
    end
    // generate reset
    initial 
    begin 
        reset = '0;
        repeat( rst_delay ) @(posedge clk);
        reset = '1;
    end
    // working with output matrix
    initial
    begin
        @(posedge reset);
        forever
        begin
            cycle_bit = '0;
            @(posedge clk);
            if( reset )
            begin
                if( matrix_out.set_image_RGB( { { 8 { rgb[2] } } , { 8 { rgb[1] } } , { 8 { rgb[0] } } } ) )
                begin
                    old_time = get_current_time();
                    matrix_out.save_matrix();
                    c_time = get_current_time();
                    $display( "Save time = %d", c_time-old_time );
                    cycle_bit = '1;
                end
            end
        end
    end

endmodule : MinesweeperFPGA_tb
