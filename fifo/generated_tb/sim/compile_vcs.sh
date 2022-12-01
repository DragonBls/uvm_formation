#!/bin/sh
vcs -sverilog +acc +vpi -timescale=1ns/1ps -ntb_opts uvm-1.2 \
+incdir+../tb/include \
+incdir+../tb/fifo_in/sv \
+incdir+../tb/fifo_out/sv \
+incdir+../tb/top/sv \
+incdir+../tb/top_test/sv \
+incdir+../tb/top_tb/sv \
-F ../dut/files.f \
../tb/fifo_in/sv/fifo_in_pkg.sv \
../tb/fifo_in/sv/fifo_in_if.sv \
../tb/fifo_out/sv/fifo_out_pkg.sv \
../tb/fifo_out/sv/fifo_out_if.sv \
../tb/top/sv/top_pkg.sv \
../tb/top_test/sv/top_test_pkg.sv \
../tb/top_tb/sv/top_th.sv \
../tb/top_tb/sv/top_tb.sv \
-R +UVM_TESTNAME=top_test  $* 
