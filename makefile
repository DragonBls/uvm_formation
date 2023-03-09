VERIF_DIR = /home/formation4/uvm_training/fifo #$(PIWORKSPACE)/data/bms1qphy_sir_lib/bms1qphy_sir_verif
VIP_DIR = $(VERIF_DIR)/output/vip #precise VIP directory
TB_DIR = $(VERIF_DIR)/output/top/tb # precise TB directory


#TB_INC = +incdir+$(VIP_DIR)... # add VIP directories to be seareched for `include directive
#TB_INC += +incdir+$(TB_DIR)... # add VIP directories to be seareched for `include directive


#TB_FILES = $(VIP_DIR)/XXX.pkg # add VIP pkg files
#TB_FILES += $(TB_DIR)/XXX.pkg # add TB pkg files 


UVM_TESTNAME            ?= top_test                                                                                                                   
UVM_VSEQNAME            ?= vseq_uc_host_tpl                                                                                                      
SEED                    ?= random                                                                                                                       
VERBOSITY               ?= UVM_LOW                                                                                                                      
                                                                                                                                                        
                                                                                                                                                       
#----------------------------------------------------------------------
#      Functions
#----------------------------------------------------------------------


elab:  
	xrun -64 -uvm -access +rwc -sv -work work -sysv_ext +.pkg -timescale 1ns/1ps $(TB_INC) $(TB_FILES) +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(UVM_TESTNAME) -svseed $(SEED) +UVM_VSEQNAME=$(UVM_VSEQNAME) -uvmhome /pkg/cadence-xcelium-/20.03.004/i686-linux/tools/methodology/UVM/CDNS-1.1d -elaborate                      


run:
	xrun -64 -uvm -access +rwc -sv -work work -sysv_ext +.pkg -timescale 1ns/1ps $(TB_INC) $(TB_FILES) +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(UVM_TESTNAME) -svseed $(SEED) +UVM_VSEQNAME=$(UVM_VSEQNAME) -uvmhome /pkg/cadence-xcelium-/20.03.004/i686-linux/tools/methodology/UVM/CDNS-1.1d                               


gui:  
	xrun -64 -uvm -access +rwc -sv -work work -sysv_ext +.pkg -timescale 1ns/1ps $(TB_INC) $(TB_FILES) +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(UVM_TESTNAME) -svseed $(SEED) +UVM_VSEQNAME=$(UVM_VSEQNAME) -uvmhome /pkg/cadence-xcelium-/20.03.004/i686-linux/tools/methodology/UVM/CDNS-1.1d -gui                             


batch:  
	xrun -64 -uvm -access +rwc -sv -work work -sysv_ext +.pkg -timescale 1ns/1ps $(TB_INC) $(TB_FILES) +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(UVM_TESTNAME) -svseed $(SEED) +UVM_VSEQNAME=$(UVM_VSEQNAME) -uvmhome /pkg/cadence-xcelium-/20.03.004/i686-linux/tools/methodology/UVM/CDNS-1.1d -batch                          


clean:
	rm -rf xrun.* xcelium.d waves.* .simvision imc.* simvision*
