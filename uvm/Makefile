# Variables
TBTOP=axi_master_duv_tb
# FUSESOC=fusesoc_libraries/digital-lib/edge_detector/src/socetlib_edge_detector.sv

# Name of UVM test to be run
TESTNAME=master_test
VERBOSITY=UVM_MEDIUM
# SEED=$(shell echo $$RANDOM)


# Ensure QUESTA_HOME is set to the QuestaSim installation directory
QUESTA_HOME?=/package/eda/mg/questa10.6b/questasim

# Makefile Targets
all: build run_gui


# incdir added
build:
	@echo "Building testbench and DUT..."
	vlog +acc \
	+cover \
	-L $(QUESTA_HOME)/uvm-1.2 \
	$(TBTOP).sv \
	-logfile tb_compile.log \
	-printinfilenames=file_search.log 

run: build
	vsim -c $(TBTOP) -L \
	$(QUESTA_HOME)/uvm-1.2 -novopt \
	-voptargs=+acc \
	-coverage \
	+UVM_TESTNAME="$(TESTNAME)" \
	+UVM_VERBOSITY=$(VERBOSITY) \
	-do "run -all" &
	


clean:
	@echo "Cleaning up..."
	rm -rf work
	rm -f wlf*
	rm -f transcript	
	rm -f *.log
	rm -f *.vstf
	rm -f *.wlf


clear:
	clear
	clear

run_gui: build 
	clear
	clear
	@echo "Running simulation in GUI mode..."
	vsim -coverage -i $(TBTOP) -L \
	$(QUESTA_HOME)/uvm-1.2 \
	-voptargs=+acc \
	+UVM_TESTNAME="$(TESTNAME)" \
	+UVM_VERBOSITY=$(VERBOSITY) \
	-do "do wave.do" -do "run -all" &

.PHONY: build run run_gui clean all clear