#
# File            :   ppm_test.tcl
# Autor           :   Vlasov D.V
# Data            :   20.02.2021
# Language        :   TCL
# Description     :   This is script for running ppm example test
# Copyright(c)    :   2019-2021 Vlasov D.V
#

set test    "ppm_test"

vlog -sv ../ppm_test/ppm_test.sv

vsim -novopt work.ppm_test

run -all

wave zoom full

quit
