#
# File            :   dpi_test.tcl
# Autor           :   Vlasov D.V
# Data            :   23.02.2020
# Language        :   TCL
# Description     :   This is script for running dpi example test
# Copyright(c)    :   2019-2021 Vlasov D.V
#

workspace create w_sim
design create -a w_sim .

set i0 +incdir+$dsn/../../dpi_examples

set s0 $dsn/../../dpi_examples/*.*v

alog -dbg -O2 -sve -msg 5 -sv2k12 $i0 $s0

asim -novopt -sv_lib $dsn/../../dpi_lib/dpi_test.lib work.dpi_test

run -all
