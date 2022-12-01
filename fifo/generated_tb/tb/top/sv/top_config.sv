`ifndef TOP_CONFIG_SV
`define TOP_CONFIG_SV

class top_config extends uvm_object;

  // Do not register config class with the factory

  rand fifo_in_config   m_fifo_in_config; 
  rand fifo_out_config  m_fifo_out_config;

  // You can insert variables here by setting config_var in file common.tpl

  extern function new(string name = "");

endclass : top_config 


function top_config::new(string name = "");
  super.new(name);

  m_fifo_in_config                  = new("m_fifo_in_config"); 
  m_fifo_in_config.is_active        = UVM_ACTIVE;              
  m_fifo_in_config.checks_enable    = 1;                       
  m_fifo_in_config.coverage_enable  = 1;                       

  m_fifo_out_config                 = new("m_fifo_out_config");
  m_fifo_out_config.is_active       = UVM_ACTIVE;              
  m_fifo_out_config.checks_enable   = 1;                       
  m_fifo_out_config.coverage_enable = 1;                       

endfunction : new


`endif // TOP_CONFIG_SV

