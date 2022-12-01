`ifndef TOP_SCOREBOARD 
`define TOP_SCOREBOARD 
 
`uvm_analysis_imp_decl(_fifo_in_pkt) 
`uvm_analysis_imp_decl(_fifo_out_pkt) 
   
class top_scoreboard extends uvm_scoreboard; 
  `uvm_component_utils(top_scoreboard) 

  fifo_in_item data_in_que[$]; 
  fifo_out_item data_out_que[$]; 

  uvm_analysis_imp_fifo_in_pkt #(fifo_in_item,top_scoreboard) fifo_in_port; 
  uvm_analysis_imp_fifo_out_pkt #(fifo_out_item,top_scoreboard) fifo_out_port; 
   
  function new(string name, uvm_component parent); 
    super.new(name, parent); 
    fifo_in_port = new("fifo_in_port", this); 
    fifo_out_port = new("fifo_out_port", this); 
  endfunction : new 
   
  virtual function void write_fifo_in_pkt(input fifo_in_item pkt); 
    data_in_que.push_back(pkt);
  endfunction : write_fifo_in_pkt 

  virtual function void write_fifo_out_pkt(input fifo_out_item pkt); 
    data_out_que.push_back(pkt); 
  endfunction : write_fifo_out_pkt 


  virtual function void report(); 
    uvm_report_info(get_type_name(), 
    $psprintf("Scoreboard Report %s", this.sprint()), UVM_LOW); 
  endfunction : report 
 
endclass : top_scoreboard 
`endif 
