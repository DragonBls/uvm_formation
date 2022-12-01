`ifndef FIFO_IN_IF_SV
`define FIFO_IN_IF_SV

interface fifo_in_if(); 

  timeunit      1ns;
  timeprecision 1ps;

  import fifo_in_pkg::*;
  
  wire clk;
  wire [31:0] data_in;
  wire data_in_vld;
  wire data_in_rdy;

  // You can insert properties and assertions here
	clocking cb_drv @(posedge clk);
		input data_in_rdy;
		output data_in_vld;
		output data_in;
	endclocking

	clocking cb_mon @(posedge clk);
		input data_in_rdy;
		input data_in_vld;
		input data_in;
	endclocking

endinterface : fifo_in_if

`endif // FIFO_IN_IF_SV

