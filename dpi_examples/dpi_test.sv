/*
*  File            :   dpi_test.sv
*  Autor           :   Vlasov D.V
*  Data            :   12.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is testbench for working with DPI
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

import "DPI-C" function void dpi_get_dv(output int val);
import "DPI-C" function void dpi_create_tda(int size_0, int size_1);
import "DPI-C" function void dpi_free_tda();
import "DPI-C" function void dpi_print_tda(int size_0, int size_1);
import "DPI-C" context function void dpi_rand_tda(int size_0, int size_1);
import "DPI-C" function int   dpi_ret_e_tda(input int pos_0, int pos_1);
import "DPI-C" function void  dpi_get_e_tda(input int pos_0, int pos_1, output int element);
import "DPI-C" function void  dpi_get_tda(output int arr[][], input int size_0, int size_1);
import "DPI-C" function void dpi_set_tda(int arr[][], int size_0, int size_1);
import "DPI-C" function int  dpi_comp_arr(int arr[][], int size_0, int size_1);

module dpi_test;

    timeunit            1ns;
    timeprecision       1ns;

    int tda [][];
    int size_0 = 3;
    int size_1 = 3;

    initial
    begin
        dpi_get_dv(size_0);
        dpi_get_dv(size_1);
        $display("size_0 = %4d, size_1 = %4d", size_0, size_1);
        $display("Creating SystemVerilog two dimentional array");
        tda = new [size_0];
        foreach( tda[i] )
            tda[i] = new [size_1];
        $display("Creating C two dimentional array");        
        dpi_create_tda(size_0,size_1);
        $display("Randomize C array");
        dpi_rand_tda(size_0,size_1);
        dpi_print_tda(size_0,size_1);
        $display("Copy values from C array to SystemVerilog array");
        foreach(tda[i,j])
            dpi_get_e_tda(i,j,tda[i][j]); // tda[i][j] = dpi_ret_e_tda(i,j);
        $display("Compare C and SystemVerilog arrays");
        dpi_comp_arr(tda,size_0,size_1);
        $display("Randomize SystemVerilog arrays");
        foreach(tda[i,j])
            tda[i][j] = $urandom_range(0,99);
        $display("Compare C and SystemVerilog arrays");
        dpi_comp_arr(tda,size_0,size_1);
        $display("Copy values from SystemVerilog array to C array");
        dpi_set_tda(tda,size_0,size_1);
        $display("Compare C and SystemVerilog arrays");
        dpi_comp_arr(tda,size_0,size_1);
        $display("Free C array");
        dpi_free_tda();
        $display("Free SystemVerilog array");
        tda.delete();
        $stop;
    end

endmodule : dpi_test
