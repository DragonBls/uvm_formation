`ifndef FIFO_IN_SEQ_ITEM_SV
`define FIFO_IN_SEQ_ITEM_SV

class fifo_in_item extends uvm_sequence_item; 

  `uvm_object_utils(fifo_in_item)

  // To include variables in copy, compare, print, record, pack, unpack, and compare2string, define them using trans_var in file ./fifo_in.tpl
  // To exclude variables from compare, pack, and unpack methods, define them using trans_meta in file ./fifo_in.tpl

  // Transaction variables
  rand bit [31:0] data;
  rand int delay;

  constraint c_delay {delay inside {[0:100]};}

  extern function new(string name = "");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void do_record(uvm_recorder recorder);
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function string convert2string();

endclass : fifo_in_item 


function fifo_in_item::new(string name = "");
  super.new(name);
endfunction : new


function void fifo_in_item::do_copy(uvm_object rhs);
  fifo_in_item rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  data = rhs_.data;
  delay = rhs_.delay;
endfunction : do_copy


function bit fifo_in_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  fifo_in_item rhs_;
  if (!$cast(rhs_, rhs))
    `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= comparer.compare_field("data", data, rhs_.data, $bits(data));
  result &= comparer.compare_field("delay", delay, rhs_.delay, $bits(delay));
  return result;
endfunction : do_compare


function void fifo_in_item::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0)
    `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else
    printer.m_string = convert2string();
endfunction : do_print


function void fifo_in_item::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // Use the record macros to record the item fields:
  `uvm_record_field("data", data)
  `uvm_record_field("delay", delay)
endfunction : do_record


function void fifo_in_item::do_pack(uvm_packer packer);
  super.do_pack(packer);
  `uvm_pack_int(data) 
  `uvm_pack_int(delay) 
endfunction : do_pack


function void fifo_in_item::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  `uvm_unpack_int(data) 
  `uvm_unpack_int(delay) 
endfunction : do_unpack


function string fifo_in_item::convert2string();
  string s;
  $sformat(s, "%s\n", super.convert2string());
  $sformat(s, {"%s\n",
  "delay = 'h%0h  'd%0d\n","data = 'h%0h  'd%0d\n"},
    get_full_name(), delay, delay,data,data);
  return s;
endfunction : convert2string


`endif // FIFO_IN_SEQ_ITEM_SV

