#
# File            :   DebugScreenCore_sv.tcl
# Autor           :   Vlasov D.V
# Data            :   01.06.2019
# Language        :   TCL
# Description     :   This is script for running DebugScreenCore SystemVerilog version testbench
# Copyright(c)    :   2019-2021 Vlasov D.V
#

set test    "DebugScreenCore_sv"
    
set i0 +incdir+../ver_classes/pkg
set i1 +incdir+../rtl/DebugScreenCore/rtl/sv
set i2 +incdir+../tb

set s0 ../ver_classes/pkg/*.*v
set s1 ../rtl/DebugScreenCore/rtl/sv/*.*v
set s2 ../tb/*.*v

vlog -sv -dpiheader ../ver_classes/dpi_h/dpiheader.h $i0 $i1 $i2 $s0 $s1 $s2 ../ver_classes/dpi_src/image.c ../ver_classes/dpi_src/help.c  

vsim -novopt work.dsc_tb
add wave -position insertpoint sim:/dsc_tb/*

run -all

wave zoom full

quit
