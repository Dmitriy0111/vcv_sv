
help:
	$(info make help         - show this message)
	$(info make clean        - delete synth and simulation folders)
	$(info make sim_cmd      - run simulation in cmd mode)
	$(info make sim          - run simulation in gui mode)
	$(info Open and read the Makefile for details)
	@true

PWD     := $(shell pwd)
RUN_DIR  = $(PWD)/run
RTL_DIR  = $(PWD)/rtl
TB_DIR   = $(PWD)/tb

########################################################
# common make targets

clean: \
	sim_clean \
	std_clean \
	in_img_clean \
	MinesweeperFPGA_clean

sim_all: \
	sim_cmd

sim: sim_gui

########################################################
# simulation - Modelsim

TEST_NAME ?= racing_game_v3_tb

VSIM_DIR = $(PWD)/sim_modelsim

VLIB_BIN = cd $(VSIM_DIR) && vlib
VLOG_BIN = cd $(VSIM_DIR) && vlog
VSIM_BIN = cd $(VSIM_DIR) && vsim

VSIM_OPT_COMMON += -do $(RUN_DIR)/$(TEST_NAME).tcl

VSIM_OPT_CMD     = -c
VSIM_OPT_CMD    += -onfinish exit

VSIM_OPT_GUI     = -onfinish stop

sim_clean:
	rm -rfd $(VSIM_DIR)
	rm -rfd output_images
	rm -rfd input_images

sim_dir: sim_clean
	mkdir $(VSIM_DIR)
	mkdir output_images
	mkdir input_images
	make load_test_image

sim_cmd: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_CMD)

sim_gui: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_GUI) &

stb_load:
	git clone https://github.com/nothings/stb
	
std_clean:
	rm -rfd stb

MinesweeperFPGA_load:
	git clone https://github.com//MinesweeperFPGA rtl/MinesweeperFPGA

MinesweeperFPGA_clean:
	rm -rfd rtl/MinesweeperFPGA

in_img_clean:
	rm -rfd input_images

load_test_image:
	cp test_image/Penguins.jpg input_images/in_image_0.jpg
	cp test_image/Penguins.ppm input_images/in_image_0.ppm
	cp test_image/Penguins.png input_images/in_image_0.png
	cp test_image/Penguins.tga input_images/in_image_0.tga
	cp test_image/Penguins.bmp input_images/in_image_0.bmp
