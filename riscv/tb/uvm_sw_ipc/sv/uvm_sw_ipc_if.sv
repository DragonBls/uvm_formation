`ifndef UVM_SW_IPC_IF_SV
`define UVM_SW_IPC_IF_SV

  `define UVM_SW_IPC_MEM top_tb.th.toplevel.data_memory_bus
  `define UVM_SW_IPC_RO_MEM top_tb.th.toplevel.text_memory_bus

  `define STRINGIFY(x) `"x`"


interface uvm_sw_ipc_if();

  timeunit      1ns;
  timeprecision 1ps;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import uvm_sw_ipc_pkg::*;


  wire clock;
  wire reset;
  wire cen;
  wire wen;
  wire [31:0] address;
  wire [31:0] rdata;
  wire [31:0] wdata;
  wire [3:0] byteen;


  clocking cb @(posedge clock);
    input reset;
    input cen;
    input wen;
    input address;
    input rdata;
    input wdata;
    input byteen;
  endclocking : cb


  function void backdoor_write(bit [31:0] addr, bit [31:0] wdata);
    assert(uvm_hdl_deposit($sformatf("%0s.data_memory.mem[%0d]", `STRINGIFY(`UVM_SW_IPC_MEM),
      addr[16:2]), wdata));
    `uvm_info("uvm_sw_ipc_if", $sformatf("backdoor_write 0x%x -> [0x%x]", wdata, addr), UVM_DEBUG);
  endfunction : backdoor_write


  function string backdoor_get_string(bit [31:0] addr);
    string str;
    bit [7:0] char;
    int i;
    str = "";
    char = ".";
    i = 0;

    while (char != 0) begin
      bit [31:0] rdata;
      int char_idx;
      int word_idx;
      char_idx = i%4;
      if (char_idx == 0) begin
        word_idx = i>>2;
        assert(uvm_hdl_read($sformatf("%0s.text_memory.mem[%0d]", `STRINGIFY(`UVM_SW_IPC_RO_MEM),
          addr[16:2] + word_idx), rdata));
      end
      char = rdata[char_idx*8 +: 8];
      str = {str, char};
      i++;
    end

    return str;
  endfunction : backdoor_get_string


endinterface : uvm_sw_ipc_if

`endif // UVM_SW_IPC_IF_SV

