#
# File            :   dpi_test_modelsim.tcl
# Autor           :   Vlasov D.V
# Data            :   12.05.2020
# Language        :   TCL
# Description     :   This is script for running dpi example test (Modelsim)
# Copyright(c)    :   2019-2021 Vlasov D.V
#

vlib work

set test "dpi_test"

vlog -sv -dpiheader ../dpi_examples/dpi_test.h ../dpi_examples/dpi_test.sv ../dpi_examples/dpi_test.c

vsim -novopt work.dpi_test

run -all

wave zoom full

quit
