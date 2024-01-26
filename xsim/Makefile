.PHONY: all

XILINX_DIR=/home/tsengs0/Xilinx/Vivado/2019.2/settings64.sh

# UVM library setup
UVM_VERSION=1.2
UVM_USER_LIB_PATH=../source/model

# RTL settings
RTL_FILELIST=uvm_rtl.f
RTL_SRC=`cat $(RTL_FILELIST)`
TOP_MODULE=apb_sram_tb

# Options for Vivado RTL elaboration and compilation
VIVADO_ELAB_OPTION= \
	-debug all \
	-L uvm \
	-uvm_version $(UVM_VERSION) 

VIVADO_XVLOG_OPTION= \
	-L uvm \
	-uvm_version $(UVM_VERSION) \
	--include $(UVM_USER_LIB_PATH)

# Options for Vivado simulation
UVM_SIM_OPTION=-R --testplusarg "UVM_TESTNAME=apb_sram_test"
VIVADO_SIM_OPTION=
#VIVADO_SIM_OPTION += -tclbatch xsim_cfg.tcl --gui --wdb $(TOP_MODULE)_waveform.wdb
#----------------------------------------------------------------------
build:
	#source $(XILINX_DIR)
	xvlog -sv $(RTL_SRC) $(VIVADO_XVLOG_OPTION)
	xelab $(TOP_MODULE) -timescale 1ns/1ps $(VIVADO_ELAB_OPTION)

run:
	xsim $(TOP_MODULE) $(UVM_SIM_OPTION) $(VIVADO_SIM_OPTION)

clean:
	rm -rf xsim.dir .Xil
	rm *.jou *.log *.pb
	rm *.vcd
