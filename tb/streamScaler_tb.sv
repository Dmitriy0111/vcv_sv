/*
*  File            :   streamScaler_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   03.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for test_hvsync
*  Copyright(c)    :   2019 Vlasov D.V
*/

`include "img_matrix.sv"

module streamScaler_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import img_matrix_pkg::*;

    parameter           T = 10,
                        rst_delay = 7,
                        rep_c = 40;

    // creating output matrix
    img_matrix img_matrix_in = new (800,600,"../input_images/","in_image_",'0);
    // creating output matrix
    img_matrix img_matrix_out = new (400,300,"../output_images/","out_image_",'1);

    bit     [0  : 0]    clk;
    bit     [0  : 0]    reset; 
    logic   [23 : 0]    rgb_in;
    logic   [23 : 0]    rgb_out;
    bit     [0  : 0]    nearestNeighbor;
    bit     [0  : 0]    start;
    bit     [0  : 0]    dInValid;
    logic   [0  : 0]    nextDin;
    logic   [0  : 0]    dOutValid;
    bit     [0  : 0]    nextDout;
    
    integer             rep_cycles = 0;

    streamScaler 
    #(
        .CHANNELS           ( 3                     ),
        .BUFFER_SIZE        ( 4                     ),
        .INPUT_X_RES_WIDTH  ( 11                    ),
	    .INPUT_Y_RES_WIDTH  ( 11                    ),
	    .OUTPUT_X_RES_WIDTH ( 11                    ),
	    .OUTPUT_Y_RES_WIDTH ( 11                    )
    )
    streamScaler_0
    (
        //---------------------------Module IO-----------------------------------------
        //Clock and reset
        .clk                ( clk                   ),
        .rst                ( reset                 ),

        //User interface
        //Input
        .dIn                ( rgb_in                ),
        .dInValid           ( dInValid              ),
        .nextDin            ( nextDin               ),
        .start              ( start                 ),

        //Output
        .dOut               ( rgb_out               ),
        .dOutValid          ( dOutValid             ),  //latency of 4 clock cycles after nextDout is asserted
        .nextDout           ( nextDout              ),
        //Control
        .inputDiscardCnt    ( 0                     ),  //Number of input pixels to discard before processing data. Used for clipping
        .inputXRes          ( 800 - 1               ),  //Resolution of input data minus 1
        .inputYRes          ( 600 - 1               ),  
        .outputXRes         ( 400 - 1               ),  //Resolution of output data minus 1
        .outputYRes         ( 300 - 1               ),
        .xScale             ( 32'h4000*2            ),  //Scaling factors. Input resolution scaled up by 1/xScale. Format Q SCALE_INT_BITS.SCALE_FRAC_BITS
        .yScale             ( 32'h4000*2            ),  //Scaling factors. Input resolution scaled up by 1/yScale. Format Q SCALE_INT_BITS.SCALE_FRAC_BITS
        .leftOffset         ( 0                     ),  //Integer/fraction of input pixel to offset output data horizontally right. Format Q OUTPUT_X_RES_WIDTH.SCALE_FRAC_BITS
        .topFracOffset      ( 0                     ),  //Fraction of input pixel to offset data vertically down. Format Q0.SCALE_FRAC_BITS
        .nearestNeighbor    ( nearestNeighbor       )   //Use nearest neighbor resize instead of bilinear
    );

    initial
    begin
        repeat(rst_delay*3) @(posedge clk);
        nearestNeighbor = '0;
        nextDout = '1;
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
        start = '1;
        @(posedge clk);
        start = '0;
        forever
        begin
            @(posedge clk);
            if( !reset )
            begin
                dInValid = '1;
                if( nextDin )
                    if( img_matrix_in.get_image_RGB( rgb_in ) )
                    begin
                        @(posedge clk);
                        dInValid = '0;
                        @(posedge clk);
                        start = '1;
                        @(posedge clk);
                        @(posedge clk);
                        start = '0;
                        @(posedge clk);
                        @(posedge clk);
                        @(posedge clk);
                        dInValid = '1;
                    end
            end
        end
    end
    initial
    begin
        forever
        begin
            @(posedge clk);
            if( !reset )
            begin
                if( dOutValid )
                    if( img_matrix_out.set_image_RGB( rgb_out ) )
                    begin
                        img_matrix_out.load_img_to_mem();
                        rep_cycles ++;
                        if( rep_cycles == rep_c )
                            $stop;
                    end
            end
        end
    end

endmodule : streamScaler_tb
