set test    "img_matrix_tb"
set test    "DebugScreenCore_sv"
set test    "DebugScreenCore_vhdl"
#set test    "racing_game_v3_tb"
#set test    "test_hvsync_tb"
set test    "MinesweeperFPGA"

if {$test == "img_matrix_tb"} {

    set i0 +incdir+../tb

    set s0 ../tb/*.*v

    vlog -sv ../tb/img_matrix/img_matrix.sv

    vlog -sv -dpiheader ../tb/image.h $i0 $s0 ../tb/image.c  

    vsim -novopt work.img_matrix_tb
    add wave -position insertpoint sim:/img_matrix_tb/*

} elseif {$test == "DebugScreenCore_sv"} {
    
    set i0 +incdir+../rtl/DebugScreenCore/rtl/sv
    set i0 +incdir+../tb

    set s0 ../rtl/DebugScreenCore/rtl/sv/*.*v
    set s0 ../tb/*.*v

    vlog -sv ../tb/img_matrix/img_matrix.sv

    vlog -sv -dpiheader ../tb/image.h $i0 $i1 $s0 $s1 ../tb/image.c  

    vsim -novopt work.dsc_tb
    add wave -position insertpoint sim:/dsc_tb/*

} elseif {$test == "DebugScreenCore_vhdl"} {
    
    set i0 +incdir+../tb

    set s0 ../tb/*.*v

    vcom -2008 ../rtl/DebugScreenCore/inc/vhdl/dsc_help_pkg.vhd     -work dsc
    vcom -2008 ../rtl/DebugScreenCore/inc/vhdl/dsc_mem_pkg.vhd      -work dsc
    vcom -2008 ../rtl/DebugScreenCore/inc/vhdl/dsc_components.vhd   -work dsc
    vcom -2008 ../rtl/DebugScreenCore/vga_mem/vhdl/*.vhd            -work dsc

    vcom -2008 ../rtl/DebugScreenCore/rtl/vhdl/*.vhd

    vlog -sv -dpiheader ../tb/image.h ../tb/image.c  

    vlog -sv ../tb/img_matrix/img_matrix.sv

    vlog -sv $i0 $s0

    vsim -novopt work.dsc_tb
    add wave -position insertpoint sim:/dsc_tb/*

} elseif {$test == "racing_game_v3_tb"} {
    
    set i0 +incdir+../rtl/wrapper_for_8bitworkshop/rtl
    set i1 +incdir+../rtl/wrapper_for_8bitworkshop/fpga-examples
    set i2 +incdir+../rtl/wrapper_for_8bitworkshop/schoolMIPS-01_mmio/src
    set i3 +incdir+../tb

    set s0 ../rtl/wrapper_for_8bitworkshop/rtl/*.*v
    set s1 ../rtl/wrapper_for_8bitworkshop/fpga-examples/*.*v
    set s2 ../rtl/wrapper_for_8bitworkshop/schoolMIPS-01_mmio/src/*.*v
    set s3 ../tb/*.*v

    vlog -sv ../tb/img_matrix/img_matrix.sv

    vlog -sv -dpiheader ../tb/image.h $i0 $i1 $i2 $i3 $s0 $s1 $s2 $s3 ../tb/image.c  

    vsim -novopt work.racing_game_v3_tb
    add wave -position insertpoint sim:/racing_game_v3_tb/*

} elseif {$test == "test_hvsync_tb"} {
    
    set i0 +incdir+../rtl/wrapper_for_8bitworkshop/rtl
    set i1 +incdir+../rtl/wrapper_for_8bitworkshop/fpga-examples
    set i2 +incdir+../rtl/wrapper_for_8bitworkshop/schoolMIPS-01_mmio/src
    set i3 +incdir+../tb

    set s0 ../rtl/wrapper_for_8bitworkshop/rtl/*.*v
    set s1 ../rtl/wrapper_for_8bitworkshop/fpga-examples/*.*v
    set s2 ../rtl/wrapper_for_8bitworkshop/schoolMIPS-01_mmio/src/*.*v
    set s3 ../tb/*.*v

    vlog -sv ../tb/img_matrix/img_matrix.sv

    vlog -sv -dpiheader ../tb/image.h $i0 $i1 $i2 $i3 $s0 $s1 $s2 $s3 ../tb/image.c  

    vsim -novopt work.test_hvsync_tb
    add wave -position insertpoint sim:/test_hvsync_tb/*

} elseif {$test == "MinesweeperFPGA"} {

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

    set i0 +incdir+../tb
    set s0 ../tb/*.*v

    vlog -sv ../tb/img_matrix/img_matrix.sv

    vlog -sv -dpiheader ../tb/image.h $i0 $s0 ../tb/image.c  

    vsim -novopt work.MinesweeperFPGA_tb
    add wave -position insertpoint sim:/MinesweeperFPGA_tb/*
    add wave -position insertpoint sim:/MinesweeperFPGA_tb/ctrl_main_block_0/x_keyboard/*
    add wave -position insertpoint sim:/MinesweeperFPGA_tb/ctrl_main_block_0/x_keyboard/x_key/*
    add wave -position insertpoint sim:/MinesweeperFPGA_tb/ctrl_main_block_0/x_ctrl_game_block/*

}

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

run -all

wave zoom full

quit
