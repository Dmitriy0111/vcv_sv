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
    `include    "../pat_matrix/pat_matrix.sv"

    function real comp_matrixes(base_matrix a, base_matrix b);
        real equality;
        
        real loss_r;
        real loss_g;
        real loss_b;

        real loss_v;

        equality = 0;
        loss_r = 0;
        loss_g = 0;
        loss_b = 0;

        if( ( a.Width != b.Width ) && ( a.Height != b.Height ) )
            $display("Matrixes has other size");
        else
        begin
            foreach(a.R[i,j])
            begin
                loss_v = ( a.R[i][j] - b.R[i][j] );
                loss_v *= loss_v;
                loss_r += loss_v / a.Resolution;

                loss_v = ( a.G[i][j] - b.G[i][j] );
                loss_v *= loss_v;
                loss_g += loss_v / a.Resolution;

                loss_v = ( a.B[i][j] - b.B[i][j] );
                loss_v *= loss_v;
                loss_b += loss_v / a.Resolution;
            end
            loss_r /= 256 * 256;
            loss_g /= 256 * 256;
            loss_b /= 256 * 256;
            equality = 1 - ( loss_r + loss_g + loss_b );
            equality = ( equality < 0 ) ? 0 : equality;
            $display("loss_R=%f loss_G=%f loss_B=%f equality = %f", loss_r, loss_g, loss_b, equality);  
        end
        return equality;
    endfunction : comp_matrixes
    
endpackage : work_pkg
