/*
*  File            :   work_pkg.sv
*  Autor           :   Vlasov D.V
*  Data            :   15.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is work package
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

package work_pkg;

    import "DPI-C" function int get_current_time();

    `include    "../gist_c.sv"
    `include    "../base_matrix.sv"
    `include    "../ppm_matrix/ppm_matrix.sv"
    `include    "../img_matrix/img_matrix.sv"
    
endpackage : work_pkg
