#
# File            :   test_matrix_tb_active.tcl
# Autor           :   Vlasov D.V
# Data            :   23.02.2020
# Language        :   TCL
# Description     :   This is script for running matrix testbench (Active-HDL)
# Copyright(c)    :   2019-2021 Vlasov D.V
#

workspace create w_sim
design create -a w_sim .

set i0 +incdir+$dsn/../../ver_classes/pkg
set i1 +incdir+$dsn/../../tb

set s0 $dsn/../../ver_classes/pkg/*.*v
set s1 $dsn/../../tb/*.*v

alog -dbg -O2 -sve -msg 5 -sv2k12 $i0 $i1 $s0 $s1

asim -sv_lib $dsn/../../dpi_vcv_lib/dpi_vcv_lib.lib -novopt work.test_matrix_tb

add wave /test_matrix_tb

run -all
