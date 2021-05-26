# Video core verification (SystemVerilog)

    This is my sandbox for creating verification classes for video cores. (Used https://github.com/nothings/stb).

## Quick start:

    1) Install modelsim or questasim or Active-HDL simulator;
    2) Install make;
    3) Install gcc (for compiling dpi libraries);
    4) Call terminal or cmd;
    5) Set variables (PATH2MODELSIM or PATH2ACTIVE_HDL in help.mk);
    6) Set SIM_NAME (Active-HDL or Modelsim) and TEST_NAME;
    7) Run "make stb_load" for loading nothings/stb repository in project folder;
    8) Compile DPI library (comp_dpi_vcv_dll, comp_dpi_dll)
    9) Run "make load_all_rtl" for loading all rtl repositories for testing;
    10) Run "make create_imagesf" for creating input_images and output_images folders;
    11) Run "make load_test_image" for loading test images from test_images to input_images folder;
    12) Execute "set TEST_NAME=<test_name>" or "export TEST_NAME=<test_name>" for set current test; *
    13) Execute "make sim_cmd" or "make sim" for run simulation process;
    14) See results in output_images folder;

    * See names in "Testbenches"

## Testbenches:
    1) MinesweeperFPGA_tb is testbench for Minesweeper game (https://github.com/capitanov/MinesweeperFPGA). TEST_NAME=MinesweeperFPGA_tb;
    2) dsb_tb is testbench for DebugScreenCore (VHDL and SystemVerilog versions) (https://github.com/dmitriy0111/DebugScreenCore). TEST_NAME=DebugScreenCore_sv or TEST_NAME=DebugScreenCore_vhdl;
    3) racing_game_v3_tb is testbench for modified racing game (https://github.com/dmitriy0111/wrapper_for_8bitworkshop based on https://github.com/sehugg/fpga-examples). TEST_NAME=racing_game_v3_tb;
    4) test_hvsync_tb is testbench for modified hvsync test (https://github.com/dmitriy0111/wrapper_for_8bitworkshop based on https://github.com/sehugg/fpga-examples). TEST_NAME=test_hvsync_tb;
    5) test_matrix_tb is testbench for testing saving and loading test images (Penguins). TEST_NAME=test_matrix_tb;
    6) dpi_test is testbench for working with DPI-C and SystemVerilog. TEST_NAME=dpi_test;
    7) simple_test is testbench for testing features matrixes. TEST_NAME=simple_test;

## Folders:

| Folder name   | Description                                                               |
|---------------|---------------------------------------------------------------------------|
| doc           | This folder consist documentaion                                          |
| dpi_examples  | This folder consist base dpi examples for working with DPI-C              |
| rtl           | This folder consist rtl designs for testing                               |
| run           | This folder consist tcl scripts for running simulation process            |
| stb           | This folder consist stb repository                                        |
| tb            | This folder consist testbenches for rtl designs                           |
| test_image    | This folder consist Penguins images in JPEG, PNG, TGA, BMP, PPM formats   |
| ver_classes   | This folder consist components for verification process                   |
