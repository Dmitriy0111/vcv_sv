/*
*  File            :   keyboard_if.sv
*  Autor           :   Vlasov D.V
*  Data            :   15.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is keyboard class
*  Copyright(c)    :   2019-2020 Vlasov D.V
*/

`ifndef KEYBOARD_C__SV
`define KEYBOARD_C__SV

class keyboard_c;

    virtual keyboard_if vif;

    int period;

    extern function new(virtual keyboard_if vif_i, int period_i);

    extern task     reset_signals();

    extern task     keyboard_send(logic [7 : 0] data);

    extern task     key_toggle(logic [7 : 0] data);

endclass : keyboard_c

function keyboard_c::new(virtual keyboard_if vif_i, int period_i);
    vif = vif_i;
    period = period_i;
endfunction : new

task keyboard_c::reset_signals();
    vif.ps2_data = '1;
    vif.ps2_clk = '1;
endtask : reset_signals

task keyboard_c::key_toggle(logic [7 : 0] data);
    keyboard_send( data );
    repeat( 10000 ) @(posedge vif.clk);
    keyboard_send( 8'hF0 );
    repeat( 10000 ) @(posedge vif.clk);
endtask : key_toggle

task keyboard_c::keyboard_send(logic [7 : 0] data);
    bit odd_parity;

    odd_parity = ~^data;
    // generate start
    vif.ps2_data = '0;
    repeat( period / 2 ) @(posedge vif.clk);
    vif.ps2_clk = '0;
    repeat( period / 2 ) @(posedge vif.clk);
    vif.ps2_clk = '1;
    // send byte
    repeat( 8 )
    begin
        vif.ps2_data = data[0];
        repeat( period / 2 ) @(posedge vif.clk);
        vif.ps2_clk = '0;
        repeat( period / 2 ) @(posedge vif.clk);
        vif.ps2_clk = '1;
        data = data >> 1;
    end
    // generate parity
    vif.ps2_data = odd_parity;
    repeat( period / 2 ) @(posedge vif.clk);
    vif.ps2_clk = '0;
    repeat( period / 2 ) @(posedge vif.clk);
    vif.ps2_clk = '1;
    // generate stop
    vif.ps2_data = '1;
    repeat( period / 2 ) @(posedge vif.clk);
    vif.ps2_clk = '0;
    repeat( period / 2 ) @(posedge vif.clk);
    vif.ps2_clk = '1;
endtask : keyboard_send

`endif // KEYBOARD_C__SV
