`ifndef PUSH_DATA_TEST_SV
`define PUSH_DATA_TEST_SV

class push_data_test extends base_test;

  `uvm_component_utils(push_data_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern task run_phase(uvm_phase phase);

endclass : push_data_test


task push_data_test::run_phase(uvm_phase phase);
  bit[31:0] data;
  int i;
  super.run_phase(phase);

  `uvm_sw_ipc_wait_event(0);

  `uvm_info(get_type_name(), "check SW -> UVM data is correct", UVM_LOW)
  // fifo 0
  i = 0;
  while (`uvm_sw_ipc_pull_data(0, data)) begin
    if (data != i) begin
      `uvm_fatal(get_type_name(), $sformatf("expected_data=%0d, got data=%0d instead", i, data))
    end
    i++;
  end
  // fifo 1
  i = 0;
  while (`uvm_sw_ipc_pull_data(1, data)) begin
    if (data != i*2) begin
      `uvm_fatal(get_type_name(), $sformatf("expected_data=%0d, got data=%0d instead", i*2, data))
    end
    i++;
  end
  `uvm_info(get_type_name(), "SW -> UVM data is correct", UVM_LOW)

  // C-side should stop the test, but we have not implemented the UVM->C functions yet
  m_env.m_uvm_sw_ipc.m_quit = 1;
endtask : run_phase

`endif // PUSH_DATA_TEST_SV
