/*
*  File            :   img_matrix_tb.sv
*  Autor           :   Vlasov D.V
*  Data            :   01.06.2019
*  Language        :   SystemVerilog
*  Description     :   This is testbench file for img matrix file
*  Copyright(c)    :   2019 Vlasov D.V
*/

`include "img_matrix.sv"

module img_matrix_tb;

    timeunit            1ns;
    timeprecision       1ns;

    import img_matrix_pkg::*;

    parameter           T = 10,
                        rst_delay = 7;

    bit     [0  : 0]    clk;        // clock
    logic   [7  : 0]    R;          // R-color
    logic   [7  : 0]    G;          // G-color
    logic   [7  : 0]    B;          // B-color

    // creating output matrix
    img_matrix img_matrix_in = new (800,600,"../input_images/","in_image_",'0, '0 );
    // creating output matrix
    img_matrix img_matrix_out = new (800,600,"../output_images/","out_image_",'1, '0 );

    // generate clock
    initial 
    begin
        forever 
            #(T/2) clk = ~ clk;
    end
    // working with output matrix
    initial
    begin
        forever
        begin
            {R,G,B} = img_matrix_in.get_image_RGB();
            @(posedge clk);
            #(1ns);
            if( img_matrix_out.set_image_RGB({~R,~G,~B}) )
            begin
                img_matrix_out.load_img_to_txt();
                #(T*10);
            end
        end
    end

endmodule : img_matrix_tb
