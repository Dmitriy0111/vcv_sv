/*
*  File            :   keyboard_if.sv
*  Autor           :   Vlasov D.V
*  Data            :   15.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is keyboard interface
*  Copyright(c)    :   2019-2020 Vlasov D.V
*/

`ifndef KEYBOARD_IF__SV
`define KEYBOARD_IF__SV

interface keyboard_if (input logic [0 : 0] clk, logic [0 : 0] reset);

    bit     [0 : 0]     ps2_data;
    bit     [0 : 0]     ps2_clk;
    
endinterface : keyboard_if

`endif // KEYBOARD_IF__SV
