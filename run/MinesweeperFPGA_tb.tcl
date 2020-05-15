#
# File            :   MinesweeperFPGA_tb.tcl
# Autor           :   Vlasov D.V
# Data            :   01.06.2019
# Language        :   TCL
# Description     :   This is script for running MinesweeperFPGA testbench
# Copyright(c)    :   2019-2020 Vlasov D.V
#

set test    "MinesweeperFPGA_tb"

vlib work

vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/ctrl_types_pkg.vhd    -work   work

vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/cl_borders.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/cl_check.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/cl_mines.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/cl_select_text.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/cl_square.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/cl_text.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/ctrl_comp_pkg.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/ctrl_game_block.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/game_cores/ctrl_rounds_rom.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/keyboard/ctrl_key_decoder.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/keyboard/debounce.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/keyboard/ps2_keyboard.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/vga_main/ctrl_8x16_rom.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/vga_main/ctrl_vga640x480.vhd
vcom -2008  ../rtl/MinesweeperFPGA/src/top_level/ctrl_main_block.vhd

set i0 +incdir+../ver_classes/pkg
set i1 +incdir+../tb/MinesweeperFPGA

set s0 ../ver_classes/pkg/*.*v
set s1 ../tb/MinesweeperFPGA/MinesweeperFPGA_tb.sv

vlog -sv ../tb/MinesweeperFPGA/keyboard_if.sv

vlog -sv ../tb/MinesweeperFPGA/keyboard_pkg.sv

vlog -sv -dpiheader ../ver_classes/dpi_h/dpiheader.h $i0 $i1 $s0 $s1 ../ver_classes/dpi_src/image.c ../ver_classes/dpi_src/help.c 

vsim -novopt work.MinesweeperFPGA_tb
add wave -position insertpoint sim:/MinesweeperFPGA_tb/*
add wave -position insertpoint sim:/MinesweeperFPGA_tb/ctrl_main_block_0/x_keyboard/*
add wave -position insertpoint sim:/MinesweeperFPGA_tb/ctrl_main_block_0/x_keyboard/x_key/*
add wave -position insertpoint sim:/MinesweeperFPGA_tb/ctrl_main_block_0/x_ctrl_game_block/*

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

run -all

wave zoom full

quit
