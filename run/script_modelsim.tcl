if [file exists work] {
    vdel -all
}
vlib work

set i0 +incdir+../rtl/DebugScreenCore/rtl
set i1 +incdir+../tb

set s0 ../rtl/DebugScreenCore/rtl/*.*v
set s1 ../tb/*.*v
set s2 ../tb/*.*c
set s3 ../tb/*.*h

vlog -sv -dpiheader ../tb/image.h $i0 $i1 $s0 $s1 ../tb/image.c  
vsim -novopt work.img_matrix_tb
add wave -position insertpoint sim:/img_matrix_tb/*
run -all

wave zoom full

quit
