`ifndef PULL_DATA_TEST_SV
`define PULL_DATA_TEST_SV

class pull_data_test extends base_test;

  `uvm_component_utils(pull_data_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern task run_phase(uvm_phase phase);

endclass : pull_data_test


task pull_data_test::run_phase(uvm_phase phase);
  bit[31:0] data;
  super.run_phase(phase);

  for (int i = 0; i < 1024; i++) begin
    `uvm_sw_ipc_push_data(0, 2*i);
    `uvm_sw_ipc_push_data(1, 7*i);
  end
  `uvm_info(get_type_name(), "UVM -> SW data has been pushed", UVM_LOW)

  `uvm_sw_ipc_gen_event(0);
endtask : run_phase

`endif // PULL_DATA_TEST_SV
