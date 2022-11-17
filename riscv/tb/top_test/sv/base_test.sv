`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  top_env m_env;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // uvm_sw_ipc defines
  `define uvm_sw_ipc_gen_event  m_env.m_uvm_sw_ipc.uvm_sw_ipc_gen_event
  `define uvm_sw_ipc_wait_event m_env.m_uvm_sw_ipc.uvm_sw_ipc_wait_event
  `define uvm_sw_ipc_push_data  m_env.m_uvm_sw_ipc.uvm_sw_ipc_push_data
  `define uvm_sw_ipc_pull_data  m_env.m_uvm_sw_ipc.uvm_sw_ipc_pull_data

endclass : base_test


function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void base_test::build_phase(uvm_phase phase);
  m_env = top_env::type_id::create("m_env", this);
endfunction : build_phase


task base_test::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "start test", UVM_LOW);
endtask : run_phase

`endif // BASE_TEST_SV
