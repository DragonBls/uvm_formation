`ifndef FIFO_OUT_COVERAGE_SV
`define FIFO_OUT_COVERAGE_SV

class fifo_out_coverage extends uvm_subscriber #(fifo_out_item);

  `uvm_component_utils(fifo_out_coverage)

  fifo_out_config m_config;    
  bit             m_is_covered;
  fifo_out_item   m_item;
     
  covergroup m_cov;
    option.per_instance = 1;
    // You may insert additional coverpoints here ...

    cp_data: coverpoint m_item.data;
    //  Add bins here if required

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input fifo_out_item t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : fifo_out_coverage 


function fifo_out_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void fifo_out_coverage::write(input fifo_out_item t);
  if (m_config.coverage_enable)
  begin
    m_item = t;
    m_cov.sample();
    // Check coverage - could use m_cov.option.goal instead of 100 if your simulator supports it
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void fifo_out_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(fifo_out_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "fifo_out config not found")
endfunction : build_phase


function void fifo_out_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase


`endif // FIFO_OUT_COVERAGE_SV

