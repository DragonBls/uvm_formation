`ifndef QUIT_TEST_SV
`define QUIT_TEST_SV

class quit_test extends base_test;

  `uvm_component_utils(quit_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : quit_test

`endif // QUIT_TEST_SV
