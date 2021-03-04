/*
*  File            :   vcv_sv_pkg.sv
*  Autor           :   Vlasov D.V
*  Data            :   15.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is vcv_sv package
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

package vcv_sv_pkg;

    import "DPI-C" function int get_current_time();

    import "DPI-C" function int run_other_app(string prog_param);

    `include    "../gist_c.sv"
    `include    "../base_matrix.sv"
    `include    "../ppm_matrix/ppm_matrix.sv"
    `include    "../img_matrix/img_matrix.sv"
    `include    "../pat_matrix/pat_matrix.sv"

    function real comp_matrixes(base_matrix a, base_matrix b);
        real loss_r;
        real loss_g;
        real loss_b;

        real eq_r;
        real eq_g;
        real eq_b;

        real eq_t_sum;
        real eq_t_mul;

        int  data_a;
        int  data_b;
        int  data;

        eq_t_sum = 0;
        eq_t_mul = 0;
        loss_r = 0;
        loss_g = 0;
        loss_b = 0;

        if( ( a.Width != b.Width ) && ( a.Height != b.Height ) )
            $display("Matrixes has other size");
        else
        begin
            foreach(a.R[i,j])
            begin
                data = a.R[i][j] - b.R[i][j];
                loss_r += $pow( $itor( data ), 2.0 );
                
                data = a.G[i][j] - b.G[i][j];
                loss_g += $pow( $itor( data ), 2.0 );
                
                data = a.B[i][j] - b.B[i][j];
                loss_b += $pow( $itor( data ), 2.0 );
            end
            loss_r /= $itor($pow(255,2)) * $itor(a.Resolution);
            loss_g /= $itor($pow(255,2)) * $itor(a.Resolution);
            loss_b /= $itor($pow(255,2)) * $itor(a.Resolution);

            eq_r = 1 - loss_r;
            eq_g = 1 - loss_g;
            eq_b = 1 - loss_b;

            eq_t_sum = ( eq_r + eq_g + eq_b ) / 3.0;
            eq_t_mul = ( eq_r * eq_g * eq_b );
            $display("Equality R=%f G=%f B=%f Total mul = %f Total sum = %f", eq_r, eq_g, eq_b, eq_t_mul, eq_t_sum);  
        end
        return eq_t_sum;
    endfunction : comp_matrixes
    
endpackage : vcv_sv_pkg
