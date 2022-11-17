`ifndef UVM_SW_IPC_CONFIG_SV
`define UVM_SW_IPC_CONFIG_SV

class uvm_sw_ipc_config extends uvm_object;

  // Do not register config class with the factory

  virtual uvm_sw_ipc_if    vif;

  // low-level API
  bit [31:0] cmd_address;
  bit [31:0] fifo_data_to_uvm_address[UVM_SW_IPC_FIFO_NB];
  bit [31:0] fifo_data_to_sw_address[UVM_SW_IPC_FIFO_NB];
  bit [31:0] fifo_data_to_sw_empty_address;

  extern function new(string name = "");

endclass : uvm_sw_ipc_config


function uvm_sw_ipc_config::new(string name = "");
  super.new(name);
  cmd_address = 'h80000000;
  for (int i = 0; i < UVM_SW_IPC_FIFO_NB; i++) begin
    fifo_data_to_uvm_address[i] = 'h80000004 + i*4;
    fifo_data_to_sw_address[i]  = 'h80000004 + (UVM_SW_IPC_FIFO_NB + i)*4;
  end
  fifo_data_to_sw_empty_address = 'h80000004 + 2*UVM_SW_IPC_FIFO_NB*4;
endfunction : new


`endif // UVM_SW_IPC_CONFIG_SV

