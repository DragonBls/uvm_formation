`ifndef BASIC_TEST_SV
`define BASIC_TEST_SV

class basic_test extends base_test;

  `uvm_component_utils(basic_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern task run_phase(uvm_phase phase);

endclass : basic_test


task basic_test::run_phase(uvm_phase phase);
  bit [31:0] data_to_uvm;
  super.run_phase(phase);

  `uvm_sw_ipc_wait_event(16);
  `uvm_info(get_type_name(), "running sequence", UVM_LOW);
  #1000;
  `uvm_info(get_type_name(), "sequence done", UVM_LOW);
  `uvm_sw_ipc_push_data(0, 32'hdeadbeef);
  `uvm_sw_ipc_push_data(0, 32'hcafedeca);
  `uvm_info(get_type_name(), "data pushed", UVM_LOW);
  `uvm_sw_ipc_gen_event(1);
  `uvm_sw_ipc_wait_event(0);
  while (`uvm_sw_ipc_pull_data(0, data_to_uvm)) begin
    `uvm_info(get_type_name(), $sformatf("data_to_uvm = 0x%0x", data_to_uvm), UVM_LOW);
  end
endtask : run_phase

`endif // BASIC_TEST_SV
