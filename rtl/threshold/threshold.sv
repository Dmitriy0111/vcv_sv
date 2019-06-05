module threshold
(
    // clock and reset
    input   logic   [0  : 0]    clk,
    input   logic   [0  : 0]    resetn,
    //
    input   logic   [23 : 0]    d_in,
    input   logic   [0  : 0]    d_in_vld,
    output  logic   [23 : 0]    d_out,
    output  logic   [0  : 0]    d_out_vld,
    //
    input   logic   [15 : 0]    input_res_x,
    input   logic   [15 : 0]    input_res_y,
    input   logic   [0  : 0]    threshold_set,
    input   logic   [23 : 0]    threshold_v,
    input   logic   [2  : 0]    threshold_c,
    input   logic   [1  : 0]    threshold_a
);

    logic   [7  : 0]    R_threshold [3 : 0];
    logic   [7  : 0]    G_threshold [3 : 0];
    logic   [7  : 0]    B_threshold [3 : 0];

    logic   [15 : 0]    counter_x;
    logic   [15 : 0]    counter_y;

    //assign d_out = d_in;
    assign d_out = { R_threshold[0] < d_in[23 -: 8] ? 8'hFF : 8'h00 , G_threshold[0] < d_in[15 -: 8] ? 8'hFF : 8'h00 , B_threshold[0] < d_in[7  -: 8] ? 8'hFF : 8'h00 };
    assign d_out_vld = d_in_vld;

    always_ff @(posedge clk)
    begin
        if( threshold_set )
        begin
            if( threshold_c[2] )
                R_threshold[threshold_a] <= threshold_v[23 -: 8];
            if( threshold_c[1] )
                G_threshold[threshold_a] <= threshold_v[15 -: 8];
            if( threshold_c[0] )
                B_threshold[threshold_a] <= threshold_v[7  -: 8];
        end
    end

    always_ff @(posedge clk, negedge resetn)
    begin
        if( !resetn )
        begin
            counter_x <= '0;
            counter_y <= '0;
        end
        else
        begin
            if( d_in_vld )
            begin
                counter_x <= counter_x + 1'b1;
                if( counter_x == input_res_x )
                begin
                    counter_x <= '0;
                    counter_y <= counter_y + 1'b1;
                end
                if( counter_y == input_res_y )
                begin
                    counter_x <= '0;
                    counter_y <= '0;
                end
            end
        end
    end

endmodule : threshold