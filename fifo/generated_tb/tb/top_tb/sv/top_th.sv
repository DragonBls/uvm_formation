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
    reset = 0;         // Active low reset in this example
    #75 reset = 1;
  end

  // Pin-level interfaces connected to DUT
  fifo_in_if   fifo_in_if_0(); 
  fifo_out_if  fifo_out_if_0();

  assign fifo_in_if_0.clk = clock;
  assign fifo_out_if_0.clk = clock;

  fifo fifo (
    .clk         (clock),
    .data_in     (fifo_in_if_0.data_in),
    .data_in_vld (fifo_in_if_0.data_in_vld),
    .data_in_rdy (fifo_in_if_0.data_in_rdy),
    .data_out    (fifo_out_if_0.data_out),
    .data_out_rdy(fifo_out_if_0.data_out_rdy),
    .data_out_vld(fifo_out_if_0.data_out_vld)
  );

  
  property efe;
	  @(posedge clock) (fifo_out_if_0.data_out_vld==0 ##[1:$] fifo_in_if_0.data_in_rdy==0 ##[0:$] fifo_out_if_0.data_out_vld==0);
  endproperty
  cover property (efe);

  property fef;
	  @(posedge clock) (fifo_in_if_0.data_in_rdy==0 ##[0:$] fifo_out_if_0.data_out_vld==0 ##[1:$] fifo_in_if_0.data_in_rdy==0 );
  endproperty
  cover property (fef);

endmodule

