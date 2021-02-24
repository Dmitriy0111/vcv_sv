#
# File            :   DebugScreenCore_vhdl.tcl
# Autor           :   Vlasov D.V
# Data            :   01.06.2019
# Language        :   TCL
# Description     :   This is script for running DebugScreenCore VHDL version testbench
# Copyright(c)    :   2019-2021 Vlasov D.V
#

set test    "DebugScreenCore_vhdl"
    
set i0 +incdir+../ver_classes/pkg
set i1 +incdir+../tb

set s0 ../ver_classes/pkg/*.*v
set s1 ../tb/*.*v

vcom -2008 ../rtl/DebugScreenCore/inc/vhdl/dsc_help_pkg.vhd     -work dsc
vcom -2008 ../rtl/DebugScreenCore/inc/vhdl/dsc_mem_pkg.vhd      -work dsc
vcom -2008 ../rtl/DebugScreenCore/inc/vhdl/dsc_components.vhd   -work dsc
vcom -2008 ../rtl/DebugScreenCore/vga_mem/vhdl/*.vhd            -work dsc

vcom -2008 ../rtl/DebugScreenCore/rtl/vhdl/*.vhd

vlog -sv -dpiheader ../ver_classes/dpi_h/dpiheader.h $i0 $i1 $s0 $s1 ../ver_classes/dpi_src/image.c ../ver_classes/dpi_src/help.c 

vsim -novopt work.dsc_tb

add wave -position insertpoint sim:/dsc_tb/*

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

run -all

wave zoom full

quit
