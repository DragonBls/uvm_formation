`ifndef TOP_TEST_PKG_SV
`define TOP_TEST_PKG_SV

package top_test_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import uvm_sw_ipc_pkg::*;
  import top_pkg::*;

  `include "base_test.sv"
  `include "quit_test.sv"
  `include "print_test.sv"
  `include "gen_event_test.sv"
  `include "push_data_test.sv"
  `include "wait_event_test.sv"
  `include "pull_data_test.sv"
  `include "basic_test.sv"

endpackage : top_test_pkg

`endif // TOP_TEST_PKG_SV

