#
# File            :   test_hvsync_tb_modelsim.tcl
# Autor           :   Vlasov D.V
# Data            :   01.06.2019
# Language        :   TCL
# Description     :   This is script for running test hvsync testbench
# Copyright(c)    :   2019-2021 Vlasov D.V
#

set test    "test_hvsync_tb"

set i0 +incdir+../ver_classes/pkg
set i1 +incdir+../rtl/wrapper_for_8bitworkshop/rtl
set i2 +incdir+../rtl/wrapper_for_8bitworkshop/fpga-examples
set i3 +incdir+../rtl/wrapper_for_8bitworkshop/schoolMIPS-01_mmio/src
set i4 +incdir+../tb

set s0 ../ver_classes/pkg/*.*v
set s1 ../rtl/wrapper_for_8bitworkshop/rtl/*.*v
set s2 ../rtl/wrapper_for_8bitworkshop/fpga-examples/*.*v
set s3 ../rtl/wrapper_for_8bitworkshop/schoolMIPS-01_mmio/src/*.*v
set s4 ../tb/*.*v

vlog -sv -dpiheader ../ver_classes/dpi_h/dpiheader.h $i0 $i1 $i2 $i3 $i4 $s0 $s1 $s2 $s3 $s4  ../ver_classes/dpi_src/image.c ../ver_classes/dpi_src/help.c 

vsim -novopt work.test_hvsync_tb
add wave -position insertpoint sim:/test_hvsync_tb/*

run -all

wave zoom full

quit
