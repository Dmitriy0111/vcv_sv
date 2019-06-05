
help:
	$(info make help         - show this message)
	$(info make clean        - delete synth and simulation folders)
	$(info make sim          - the same as sim_gui)
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
	std_del \
	in_img_clean \
	vss_clean \
	MinesweeperFPGA_clean

sim_all: \
	sim_cmd

sim: sim_gui

########################################################
# simulation - Modelsim

VSIM_DIR = $(PWD)/sim_modelsim

VLIB_BIN = cd $(VSIM_DIR) && vlib
VLOG_BIN = cd $(VSIM_DIR) && vlog
VSIM_BIN = cd $(VSIM_DIR) && vsim

VSIM_OPT_COMMON += -do $(RUN_DIR)/script_modelsim.tcl

VSIM_OPT_CMD     = -c
VSIM_OPT_CMD    += -onfinish exit

VSIM_OPT_GUI     = -onfinish stop

sim_clean:
	rm -rfd $(VSIM_DIR)
	rm -rfd output_images

sim_dir: sim_clean
	mkdir $(VSIM_DIR)
	mkdir output_images

sim_cmd: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_CMD)

sim_gui: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_GUI) &

stb_load:
	git clone https://github.com/nothings/stb
	
std_del:
	rm -rfd stb

MinesweeperFPGA_load:
	git clone https://github.com//MinesweeperFPGA rtl/MinesweeperFPGA

MinesweeperFPGA_clean:
	rm -rfd rtl/MinesweeperFPGA

in_img_clean:
	rm -rfd input_images

vss_clean:
	rm -rfd rtl/video_stream_scaler
