agent_name = fifo_out

trans_item = fifo_out_item

trans_var = rand bit [15:0] data;

if_port = wire clk;
if_port = wire [15:0] data_out;
if_port = wire data_out_rdy;
if_port = wire data_out_vld;

# needed to have better driver/monitor template
driver_inc = dummy.sv inline
monitor_inc = dummy.sv inline

