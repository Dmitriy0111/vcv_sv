//  Package: matrix_pkg
//
package work_pkg;

    import "DPI-C" function int get_current_time();

    
    `include    "../gist_c.sv"
    `include    "../base_matrix.sv"
    `include    "../ppm_matrix/ppm_matrix.sv"
    `include    "../img_matrix/img_matrix.sv"
    
endpackage : work_pkg
