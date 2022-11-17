`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  extern function new(string name, uvm_component parent);

  // Child agents
  uvm_sw_ipc_config m_uvm_sw_ipc_config;
  uvm_sw_ipc        m_uvm_sw_ipc;

  top_config        m_config;

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);

endclass : top_env


function top_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  if (!uvm_config_db #(top_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "Unable to get top_config")

  m_uvm_sw_ipc_config = m_config.m_uvm_sw_ipc_config;
  uvm_config_db #(uvm_sw_ipc_config)::set(this, "m_uvm_sw_ipc", "config", m_uvm_sw_ipc_config);

  m_uvm_sw_ipc = uvm_sw_ipc::type_id::create("m_uvm_sw_ipc", this);

endfunction : build_phase


function void top_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)
endfunction : connect_phase


function void top_env::end_of_elaboration_phase(uvm_phase phase);
  uvm_factory factory = uvm_factory::get();
  `uvm_info(get_type_name(), "Information printed from top_env::end_of_elaboration_phase method", UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("Verbosity threshold is %d", get_report_verbosity_level()), UVM_MEDIUM)
  uvm_top.print_topology();
  factory.print();
endfunction : end_of_elaboration_phase

`endif // TOP_ENV_SV

