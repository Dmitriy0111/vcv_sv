/*
*  File            :   simple_test.sv
*  Autor           :   Vlasov D.V
*  Data            :   03.03.2021
*  Language        :   SystemVerilog
*  Description     :   This is testbench file testing matrixes
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

module simple_test;

    timeunit            1ns;
    timeprecision       1ns;

    import vcv_sv_pkg::*;

    parameter           rep_c = 1;
                        
    parameter           width_i = 1024,
                        height_i = 768,
                        path2folder_i = "../input_images/",
                        matrix_name_i = "in_image_",
                        use_matrix_i = "img_matrix";

    parameter           width_o = 1024,
                        height_o = 768,
                        path2folder_o = "../output_images/",
                        matrix_name_o = "out_image_",
                        use_matrix_o = "img_matrix";

    bit     [23 : 0]    rgb;

    int                 rep_cycles = 0;

    event               start_compare;

    base_matrix matrix_in;

    base_matrix matrix_pat = pat_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, "Grad" );

    base_matrix matrix_comp;

    base_matrix matrix_out;

    initial
    begin
        case( use_matrix_i )
            "img_matrix"    : matrix_in = img_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, ".jpg" , {".jpg" } );
            "ppm_matrix"    : matrix_in = ppm_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, "P3"   , {"P3"   } );
            "pat_matrix"    : matrix_in = pat_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, "Grad" ,           );
            "base_matrix"   : matrix_in = base_matrix::create( width_i, height_i, path2folder_i, matrix_name_i, ".data", {".data"} );
            default         : $fatal();
        endcase
        matrix_in.load_matrix();
    end

    initial
    begin
        case( use_matrix_i )
            "img_matrix"    : matrix_comp = img_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, ".jpg" , {".jpg" } );
            "ppm_matrix"    : matrix_comp = ppm_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, "P3"   , {"P3"   } );
            "pat_matrix"    : matrix_comp = pat_matrix ::create( width_i, height_i, path2folder_i, matrix_name_i, "Grad" ,           );
            "base_matrix"   : matrix_comp = base_matrix::create( width_i, height_i, path2folder_i, matrix_name_i, ".data", {".data"} );
            default         : $fatal();
        endcase
    end

    initial
    begin
        case( use_matrix_o )
            "img_matrix"    : matrix_out = img_matrix ::create( width_o, height_o, path2folder_o, matrix_name_o, ".jpg" , {".jpg" } );
            "ppm_matrix"    : matrix_out = ppm_matrix ::create( width_o, height_o, path2folder_o, matrix_name_o, "P3"   , {"P3"   } );
            "base_matrix"   : matrix_out = base_matrix::create( width_o, height_o, path2folder_o, matrix_name_o, ".data", {".data"} );
            default         : $fatal();
        endcase
    end

    // working with output matrix
    initial
    fork
        matrix_pat.load_matrix();
        forever
        begin
            wait(start_compare.triggered);
            matrix_comp.load_matrix();
            comp_matrixes(matrix_comp,matrix_out);
            #0;
        end
        forever
        begin
            if( matrix_in.get_image_RGB( rgb ) )
            begin
                matrix_in.load_matrix();
            end
            case( $urandom_range(0,2) )
                0       : rgb = rgb;
                1       : rgb = $urandom_range(0,2**24-1);
                2       : rgb = ~rgb;
                default : rgb = rgb;
            endcase
            if( matrix_out.set_image_RGB( rgb ) )
            begin
                matrix_out.mix_arrays( matrix_pat );
                matrix_out.save_matrix();
                ->start_compare;
                #0;
                rep_cycles++;
                if( rep_cycles == rep_c )
                    $stop;
            end
        end
    join

endmodule : simple_test
