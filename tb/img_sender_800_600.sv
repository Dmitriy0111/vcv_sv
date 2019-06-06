import img_matrix_pkg :: *;

class img_sender_800_600 extends img_matrix;

    bit     [0 : 0]     start_send;

    // class constructor
    function new( string path2folder_i, string image_name_i , bit load_img = '0 );

        super.new( 800, 600, path2folder_i, image_name_i, load_img );

        start_send = '0;
        
    endfunction : new

    task toggle_start( ref bit [0 : 0] clk_r , ref bit [0 : 0] start_r );
        start_r = '1;
        @( posedge clk_r );
        start_r = '0;
        @( posedge clk_r );
    endtask : toggle_start

    task run( ref bit [0 : 0] clk_r , ref bit [0 : 0] resetn_r , ref bit [0 : 0] start_r , ref logic [23 : 0] dIn_r , ref bit [0 : 0] dInValid_r , ref logic [0 : 0] nextDin_r );
        start_r = '0;
        dIn_r = '0;
        dInValid_r = '0;
        @(negedge resetn_r);
        toggle_start( clk_r , start_r );
        forever
        begin
            begin
                dInValid_r = '1;
                this.get_image_RGB( dIn_r );
                if( nextDin_r )
                    if( this.get_image_RGB_ainc( dIn_r ) )
                    begin
                        dInValid_r = '0;
                        @(posedge resetn_r);
                        @(posedge clk_r);
                        @(posedge clk_r);
                        toggle_start( clk_r , start_r );
                        dInValid_r = '1;
                    end
            end
            @(posedge clk_r);
        end

    endtask : run

endclass : img_sender_800_600