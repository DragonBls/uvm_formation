`ifndef PRINT_TEST_SV
`define PRINT_TEST_SV

class print_test extends base_test;

  `uvm_component_utils(print_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : print_test

`endif // PRINT_TEST_SV
