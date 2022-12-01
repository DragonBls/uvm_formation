agent_name = fifo_in

trans_item = fifo_in_item

trans_var = rand bit [31:0] data;

if_port = wire clk;
if_port = wire [31:0] data_in;
if_port = wire data_in_vld;
if_port = wire data_in_rdy;


# needed to have better driver/monitor template
driver_inc = dummy.sv inline
monitor_inc = dummy.sv inline

