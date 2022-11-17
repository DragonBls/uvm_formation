module top_th;

  timeunit      1ns;
  timeprecision 1ps;


  // Example clock and reset declarations
  logic clock = 0;
  logic reset;

  // Example clock generator process
  always #10 clock = ~clock;

  // Example reset generator process
  initial
  begin
    reset = 1;         // Active low reset in this example
    #75 reset = 0;
  end

  assign uvm_sw_ipc_if_0.clock   = clock;
  assign uvm_sw_ipc_if_0.reset   = reset;
  assign uvm_sw_ipc_if_0.cen     = `UVM_SW_IPC_MEM.read_enable || `UVM_SW_IPC_MEM.write_enable;
  assign uvm_sw_ipc_if_0.wen     = `UVM_SW_IPC_MEM.write_enable;
  assign uvm_sw_ipc_if_0.address = `UVM_SW_IPC_MEM.address;
  assign uvm_sw_ipc_if_0.rdata   = `UVM_SW_IPC_MEM.read_data;
  assign uvm_sw_ipc_if_0.wdata   = `UVM_SW_IPC_MEM.write_data;
  assign uvm_sw_ipc_if_0.byteen  = `UVM_SW_IPC_MEM.byte_enable;

  // Pin-level interfaces connected to DUT
  uvm_sw_ipc_if  uvm_sw_ipc_if_0 ();

  toplevel toplevel (
    .clock           (clock),
    .reset           (reset),
    .bus_read_data   (/*unused*/),
    .bus_address     (/*unused*/),
    .bus_write_data  (/*unused*/),
    .bus_byte_enable (/*unused*/),
    .bus_read_enable (/*unused*/),
    .bus_write_enable(/*unused*/),
    .inst            (/*unused*/),
    .pc              (/*unused*/)
  );

endmodule

