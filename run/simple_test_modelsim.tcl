#
# File            :   simple_test_modelsim.tcl
# Autor           :   Vlasov D.V
# Data            :   03.03.2021
# Language        :   TCL
# Description     :   This is script for running simple testbench (Modelsim)
# Copyright(c)    :   2019-2021 Vlasov D.V
#

vlib work

set test    "simple_test"

set i0 +incdir+../ver_classes/pkg
set i1 +incdir+../tb

set s0 ../ver_classes/pkg/*.*v
set s1 ../tb/*.*v

vlog -sv -dpiheader ../ver_classes/dpi_h/dpiheader.h $i0 $i1 $s0 $s1 ../ver_classes/dpi_src/image.c ../ver_classes/dpi_src/help.c 

vsim -novopt work.simple_test
add wave -position insertpoint sim:/simple_test/*

run -all

wave zoom full

quit
