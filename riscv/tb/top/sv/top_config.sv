`ifndef TOP_CONFIG_SV
`define TOP_CONFIG_SV

class top_config extends uvm_object;

  // Do not register config class with the factory

  rand uvm_sw_ipc_config  m_uvm_sw_ipc_config;

  // You can insert variables here by setting config_var in file common.tpl

  extern function new(string name = "");

endclass : top_config


function top_config::new(string name = "");
  super.new(name);

  m_uvm_sw_ipc_config                 = new("m_uvm_sw_ipc_config");

endfunction : new


`endif // TOP_CONFIG_SV

