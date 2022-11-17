`ifndef GEN_EVENT_TEST_SV
`define GEN_EVENT_TEST_SV

class gen_event_test extends base_test;

  `uvm_component_utils(gen_event_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern task run_phase(uvm_phase phase);

endclass : gen_event_test


task gen_event_test::run_phase(uvm_phase phase);
  int q[$];
  super.run_phase(phase);

  for (int i = 0; i < UVM_SW_IPC_EVENT_NB; i++) begin
    automatic int i_auto = i;
    fork
      begin
        `uvm_sw_ipc_wait_event(i_auto);
        q.push_back(i_auto);
        `uvm_info(get_type_name(), $sformatf("uvm_sw_ipc_wait_event(%0d) done", i_auto), UVM_LOW)
      end
    join_none
  end

  `uvm_info(get_type_name(), "wait all events to be received", UVM_LOW)
  wait fork;
  `uvm_info(get_type_name(), "all events have been received", UVM_LOW)

  `uvm_info(get_type_name(), "check events were received in the right order", UVM_LOW)
  for (int i = 0; i < UVM_SW_IPC_EVENT_NB; i++) begin
    int event_idx;
    event_idx = q.pop_front();
    if (event_idx != i) begin
      `uvm_fatal(get_type_name(), $sformatf("expected_event_idx=%0d, got event_idx=%0d instead", i, event_idx))
    end
  end
  `uvm_info(get_type_name(), "events were received in the right order", UVM_LOW)

  // C-side should stop the test, but we have not implemented the UVM->C functions yet
  m_env.m_uvm_sw_ipc.m_quit = 1;
endtask : run_phase

`endif // GEN_EVENT_TEST_SV
