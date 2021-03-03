include help.mk

help:
	$(info make help				- show this message)
	$(info make clean				- delete synth and simulation folders)
	$(info make sim_cmd				- run simulation in cmd mode)
	$(info make sim					- run simulation in gui mode)
	$(info make stb_load			- load stb repository)
	$(info make stb_clean			- clean stb repository)
	$(info make load_all_rtl		- load rtl repository)
	$(info make clean_all_rtl		- clean rtl repository)
	$(info make comp_dpi_vcv_dll	- compile dpi vcv dll)
	$(info make clean_dpi_vcv_lib	- clean dpi vcv dll)
	$(info make comp_dpi_dll		- compile dpi dll)
	$(info make clean_dpi_lib		- clean dpi dll)
	$(info make create_imagesf		- create output_images and input_images folders)
	$(info make clean_imagesf		- clean output_images and input_images folders)
	$(info make load_test_image		- load test images in input_images folder)
	$(info Open and read the Makefile for details)
	@true

PWD     := $(shell pwd)
RUN_DIR  = $(PWD)/run
RTL_DIR  = $(PWD)/rtl
TB_DIR   = $(PWD)/tb

########################################################
# common make targets

clean: \
	sim_clean

sim_all: \
	sim_cmd

sim: sim_gui

########################################################
# simulation - Modelsim

TEST_NAME ?= test_matrix_tb

SIM_NAME ?= Modelsim

ifeq ($(SIM_NAME), Modelsim)
# Set actual path to modelsim win32aloem folder
PATH2SIM = $(PATH2MODELSIM)
SUB_TEST_NAME = _modelsim
endif

ifeq ($(SIM_NAME), Active-HDL)
# Set actual path to modelsim active-hdl/BIN folder
PATH2SIM = $(PATH2ACTIVE_HDL)
SUB_TEST_NAME = _active
endif

VSIM_DIR = $(PWD)/sim_modelsim

VLIB_BIN = cd $(VSIM_DIR) && "$(PATH2SIM)/vlib"
VLOG_BIN = cd $(VSIM_DIR) && "$(PATH2SIM)/vlog"
VSIM_BIN = cd $(VSIM_DIR) && "$(PATH2SIM)/vsim"

VSIM_OPT_COMMON += -do $(RUN_DIR)/$(TEST_NAME)$(SUB_TEST_NAME).tcl

VSIM_OPT_CMD     = -c
VSIM_OPT_CMD    += -onfinish exit

VSIM_OPT_GUI     = -onfinish stop

sim_clean:
	rm -rfd $(VSIM_DIR)

sim_dir: sim_clean
	mkdir $(VSIM_DIR)

sim_cmd: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_CMD)

sim_gui: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_GUI) &

########################################################
# compile dpi dll for working with Active-HDL or Modelsim

ifeq ($(SIM_NAME), Modelsim)
# Common includes paths
INCS = \
-I"$(PATH2MODELSIM)\..\include"
# Common library paths
LIBPS = \
-L"$(PATH2MODELSIM)"
# Common library names
LIBNS = \
-lmtipli \
-l:mtipli.dll
endif

ifeq ($(SIM_NAME), Active-HDL)
# Common includes paths
INCS = \
-I"$(PATH2ACTIVE_HDL)\..\PLI\Include"
# Common library paths
LIBPS = \
-L"$(PATH2ACTIVE_HDL)\..\PLI\Lib" \
-L"$(PATH2ACTIVE_HDL)\..\BIN"
# Common library names
LIBNS = \
-lsvdpi_exp \
-l:svdpi_exp.dll \
-laldecpli \
-l:aldecpli.dll
endif

comp_dpi_vcv_dll:
	mkdir -p dpi_vcv_lib
	gcc -shared -Bsymbolic \
	$(INCS) \
	$(LIBPS) \
	-Iver_classes\dpi_h \
	$(LIBNS) \
	-o dpi_vcv_lib/dpi_vcv_lib.dll \
	ver_classes/dpi_src/help.c \
	ver_classes/dpi_src/image.c

clean_dpi_vcv_lib:
	rm -rfd dpi_vcv_lib

comp_dpi_dll:
	mkdir -p dpi_lib
	gcc -shared -Bsymbolic \
	$(INCS) \
	$(LIBPS) \
	-Idpi_examples \
	$(LIBNS) \
	-o dpi_lib/dpi_test.dll \
	dpi_examples/dpi_test.c

clean_dpi_lib:
	rm -rfd dpi_lib

########################################################
# working with stb repository

stb_load:
	git clone https://github.com/nothings/stb ver_classes/dpi_src/stb
	
stb_clean:
	rm -rfd stb

########################################################
# working with rtl's examples

load_all_rtl:
	make MinesweeperFPGA_load
	make DebugScreenCore_load
	make wrapper_for_8bitworkshop_load

clean_all_rtl:
	rm -rfd rtl

MinesweeperFPGA_load:
	git clone https://github.com/capitanov/MinesweeperFPGA rtl/MinesweeperFPGA

MinesweeperFPGA_clean:
	rm -rfd rtl/MinesweeperFPGA

DebugScreenCore_load:
	git clone https://github.com/dmitriy0111/DebugScreenCore rtl/DebugScreenCore

DebugScreenCore_clean:
	rm -rfd rtl/DebugScreenCore

wrapper_for_8bitworkshop_load:
	git clone https://github.com/dmitriy0111/wrapper_for_8bitworkshop rtl/wrapper_for_8bitworkshop

wrapper_for_8bitworkshop_clean:
	rm -rfd rtl/wrapper_for_8bitworkshop

########################################################
# working with images

clean_imagesf:
	rm -rfd output_images
	rm -rfd input_images

create_imagesf:
	mkdir output_images
	mkdir input_images

load_test_image:
	cp test_image/Penguins.jpg input_images/in_image_0.jpg
	cp test_image/Penguins.ppm input_images/in_image_0.ppm
	cp test_image/Penguins.png input_images/in_image_0.png
	cp test_image/Penguins.tga input_images/in_image_0.tga
	cp test_image/Penguins.bmp input_images/in_image_0.bmp
