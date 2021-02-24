#
# File            :   dpi_test.tcl
# Autor           :   Vlasov D.V
# Data            :   12.05.2020
# Language        :   TCL
# Description     :   This is script for running dpi example test
# Copyright(c)    :   2019-2021 Vlasov D.V
#

vlib work

set test    "dpi_test"

#vlog -sv -dpiheader ../dpi_examples/dpi_test.h ../dpi_examples/dpi_test.sv
#catch { gcc -shared -Bsymbolic -ID:/intelFPGA/18.0/modelsim_ase/include -LD:/intelFPGA/18.0/modelsim_ase/win32aloem -lmtipli -l:mtipli.dll  -o dpi_test.dll ../dpi_examples/dpi_test.c }
#vsim -novopt work.dpi_test -sv_lib dpi_test

vlog -sv -dpiheader ../dpi_examples/dpi_test.h ../dpi_examples/dpi_test.sv ../dpi_examples/dpi_test.c

vsim -novopt work.dpi_test

run -all

wave zoom full

quit
