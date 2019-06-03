set test    "DebugScreenCore"
#set test    "racing_game_v3_tb"
#set test    "test_hvsync_tb"
#set test    "img_matrix_tb"

if {$test == "img_matrix_tb"} {

    set i0 +incdir+../tb

    set s0 ../tb/*.*v

    vlog -sv -dpiheader ../tb/image.h $i0 $s0 ../tb/image.c  

    vsim -novopt work.img_matrix_tb
    add wave -position insertpoint sim:/img_matrix_tb/*

} elseif {$test == "DebugScreenCore"} {
    
    set i0 +incdir+../rtl/DebugScreenCore/rtl
    set i1 +incdir+../tb

    set s0 ../rtl/DebugScreenCore/rtl/*.*v
    set s1 ../tb/*.*v
    set s2 ../tb/*.*c
    set s3 ../tb/*.*h

    vlog -sv -dpiheader ../tb/image.h $i0 $i1 $s0 $s1 ../tb/image.c  

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

    vlog -sv -dpiheader ../tb/image.h $i0 $i1 $i2 $i3 $s0 $s1 $s2 $s3 ../tb/image.c  

    vsim -novopt work.test_hvsync_tb
    add wave -position insertpoint sim:/test_hvsync_tb/*

}

run -all

wave zoom full

quit
