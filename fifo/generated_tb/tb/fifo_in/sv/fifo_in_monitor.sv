`ifndef FIFO_IN_MONITOR_SV
`define FIFO_IN_MONITOR_SV

class fifo_in_monitor extends uvm_monitor;

  `uvm_component_utils(fifo_in_monitor)

  virtual fifo_in_if vif;

  fifo_in_config     m_config;

  uvm_analysis_port #(fifo_in_item) analysis_port;

  fifo_in_item m_trans;

  extern function new(string name, uvm_component parent);

  // Methods run_phase, and do_mon generated by setting monitor_inc in file ./fifo_in.tpl
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : fifo_in_monitor 


function fifo_in_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


task fifo_in_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "run_phase", UVM_HIGH)

  m_trans = fifo_in_item::type_id::create("m_trans");
  do_mon();
endtask : run_phase

task fifo_in_monitor::do_mon();
	forever begin
		@(vif.cb_drv)
		if(vif.cb_mon.data_in_rdy && vif.cb_mon.data_in_vld) begin
			m_trans.data = vif.cb_mon.data_in;
			analysis_port.write(m_trans);
		end
	end
endtask: do_mon
// Start of inlined include file generated_tb/tb/include/dummy.sv
// End of inlined include file

`endif // FIFO_IN_MONITOR_SV

