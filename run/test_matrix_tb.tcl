#
# File            :   test_matrix_tb.tcl
# Autor           :   Vlasov D.V
# Data            :   01.06.2019
# Language        :   TCL
# Description     :   This is script for running ppm or img matrix testbench
# Copyright(c)    :   2019-2020 Vlasov D.V
#

set test    "test_matrix_tb"

set i0 +incdir+../ver_classes/pkg
set i1 +incdir+../tb

set s0 ../ver_classes/pkg/*.*v
set s1 ../tb/*.*v

vlog -sv -dpiheader ../ver_classes/dpi_h/dpiheader.h $i0 $i1 $s0 $s1 ../ver_classes/dpi_src/image.c ../ver_classes/dpi_src/help.c 

vsim -novopt work.test_matrix_tb
add wave -position insertpoint sim:/test_matrix_tb/*

run -all

wave zoom full

quit
