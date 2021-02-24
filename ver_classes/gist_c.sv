/*
*  File            :   gist_c.sv
*  Autor           :   Vlasov D.V
*  Data            :   13.05.2020
*  Language        :   SystemVerilog
*  Description     :   This is test matrix file for testing video ip cores
*  Copyright(c)    :   2019-2021 Vlasov D.V
*/

`timescale 1ns/100ps

`ifndef GIST_C_SV
`define GIST_C_SV
        
class gist_c;
        
    int             fd;
    //
    int             grey_gist[256];
    int             R_gist[256];
    int             G_gist[256];
    int             B_gist[256];
    
    extern task     find_gist(ref bit [7 : 0] R[][], ref bit [7 : 0] G[][], ref bit [7 : 0] B[][]);
    extern task     save_gist(string path2folder, string image_name, string pre_suffix);

endclass : gist_c

task gist_c::find_gist(ref bit [7 : 0] R[][], ref bit [7 : 0] G[][], ref bit [7 : 0] B[][]);
    foreach( R_gist[i] )
    begin
        R_gist[i] = '0;
        G_gist[i] = '0;
        B_gist[i] = '0;
        grey_gist[i] = '0;
    end
    foreach( R[i,j] )
    begin
        R_gist[ R[i][j] ]++;
        G_gist[ G[i][j] ]++;
        B_gist[ B[i][j] ]++;
    end
    foreach(R_gist[i])
        grey_gist[i] = ( R_gist[i] + G_gist[i] + B_gist[i] ) / 3;
endtask : find_gist

task gist_c::save_gist(string path2folder, string image_name, string pre_suffix);
    fd = $fopen( { path2folder, image_name, pre_suffix, "_gist", ".csv" } , "wb" );
    foreach( R_gist[i] )
        $fwrite( fd, "%d;%d;%d;%d;%d\n", i, R_gist[i], G_gist[i], B_gist[i], grey_gist[i] );
    $fflush( fd );
    $fclose( fd );
endtask : save_gist

`endif // GIST_C_SV
