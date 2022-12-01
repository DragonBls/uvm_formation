#!/bin/sh
IUS_HOME=`ncroot`
irun -vtimescale 1ns/1ps -uvmhome ${IUS_HOME}/tools/methodology/UVM/CDNS-1.2 \
+incdir+../../../verif_utils \
+incdir+../tb/fifo_in/sv \
+incdir+../tb/fifo_out/sv \
+incdir+../tb/top/sv \
+incdir+../tb/top_test/sv \
+incdir+../tb/top_tb/sv \
-F ../dut/files.f \
../../../verif_utils/verif_utils_pkg.sv \
../tb/fifo_in/sv/fifo_in_pkg.sv \
../tb/fifo_in/sv/fifo_in_if.sv \
../tb/fifo_out/sv/fifo_out_pkg.sv \
../tb/fifo_out/sv/fifo_out_if.sv \
../tb/top/sv/top_pkg.sv \
../tb/top/sv/top_cov.sv \
../tb/top_test/sv/top_test_pkg.sv \
../tb/top_tb/sv/top_th.sv \
../tb/top_tb/sv/top_tb.sv \
+UVM_TESTNAME=top_test  $*
