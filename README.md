# Video core verification (SystemVerilog)

    This is my sandbox for creating verification classes for video cores. (Used https://github.com/nothings/stb).

## Quick start:

    1) Install modelsim or questasim simulator;
    2) Install make;
    3) Call terminal or cmd;
    4) Run "make stb_load" for loading nothings/stb repository in project folder;
    5) Run "make load_all_rtl" for loading all rtl repositories for testing;
    6) Run "make create_imagesf" for creating input_images and output_images folders;
    7) Run "make load_test_image" for loading test images from test_images to input_images folder;
    8) Execute "set TEST_NAME=<test_name>" or "export TEST_NAME=<test_name>" for set current test; *
    9) Execute "make sim_cmd" or "make sim" for run simulation process;
    10) See results in output_images folder;

    * See names in "Testbenches"

## Testbenches:
    1) MinesweeperFPGA_tb is testbench for Minesweeper game (https://github.com/capitanov/MinesweeperFPGA). TEST_NAME=MinesweeperFPGA_tb;
    2) dsb_tb is testbench for DebugScreenCore (VHDL and SystemVerilog versions) (https://github.com/dmitriy0111/DebugScreenCore). TEST_NAME=DebugScreenCore_sv or TEST_NAME=DebugScreenCore_vhdl;
    3) racing_game_v3_tb is testbench for modified racing game (https://github.com/dmitriy0111/wrapper_for_8bitworkshop based on https://github.com/sehugg/fpga-examples). TEST_NAME=racing_game_v3_tb;
    4) test_hvsync_tb is testbench for modified hvsync test (https://github.com/dmitriy0111/wrapper_for_8bitworkshop based on https://github.com/sehugg/fpga-examples). TEST_NAME=test_hvsync_tb;
    5) test_matrix_tb is testbench for testing saving and loading test images (Penguins). TEST_NAME=test_matrix_tb;

## Folders:

| Folder name   | Description |
|---------------|-------------|
| dpi_examples  | This folder consist base dpi examples for working with DPI-C              |
| rtl           | This folder consist rtl designs for testing                               |
| run           | This folder consist tcl scripts for running simulation process            |
| stb           | This folder consist stb repository                                        |
| tb            | This folder consist testbenches for rtl folder                            |
| test_image    | This folder consist Penguins images in JPEG, PNG, TGA, BMP, PPM formats   |
| ver_classes   | This folder consist components for verification process                   |