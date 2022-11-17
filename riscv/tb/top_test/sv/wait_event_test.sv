`ifndef WAIT_EVENT_TEST_SV
`define WAIT_EVENT_TEST_SV

class wait_event_test extends base_test;

  `uvm_component_utils(wait_event_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern task run_phase(uvm_phase phase);

endclass : wait_event_test


task wait_event_test::run_phase(uvm_phase phase);
  super.run_phase(phase);

  for (int i = 0; i < UVM_SW_IPC_EVENT_NB; i++) begin
    automatic int i_auto = i;
    fork
      begin
        #(i_auto*100);
        `uvm_info(get_type_name(), $sformatf("uvm_sw_ipc_gen_event(%0d)", i_auto), UVM_LOW)
        `uvm_sw_ipc_gen_event(i_auto);
      end
    join_none
  end
endtask : run_phase

`endif // WAIT_EVENT_TEST_SV
