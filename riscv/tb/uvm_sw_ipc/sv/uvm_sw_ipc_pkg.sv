package uvm_sw_ipc_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  localparam UVM_SW_IPC_EVENT_NB = 1024;

  // UVM_SW_IPC_DATA_FIFO_NB data fifo + 1 cmd args fifo
  localparam UVM_SW_IPC_DATA_FIFO_NB  = 2;
  localparam UVM_SW_IPC_FIFO_NB = UVM_SW_IPC_DATA_FIFO_NB + 1;

  `include "uvm_sw_ipc_tx.sv"
  `include "uvm_sw_ipc_config.sv"
  `include "uvm_sw_ipc_monitor.sv"
  `include "uvm_sw_ipc.sv"

endpackage : uvm_sw_ipc_pkg
