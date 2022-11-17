transcript file questa_compile

file delete -force work

vlib work

#compile the dut code
set cmd "vlog -sv ../dut/fifo.sv"
eval $cmd

set tb_name top
set agent_list {\
    fifo_in \
    fifo_out \
}
foreach  ele $agent_list {
  if {$ele != " "} {
    set cmd  "vlog -sv +incdir+../../../verif_utils "
    append cmd "+incdir+../tb/include +incdir+../tb/" $ele "/sv "
    append cmd "../../../verif_utils/verif_utils_pkg.sv "
    append cmd "../tb/" $ele "/sv/" $ele "_pkg.sv ../tb/" $ele "/sv/" $ele "_if.sv"
    eval $cmd
  }
}

set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "/sv ../tb/" $tb_name "/sv/" $tb_name "_pkg.sv"
eval $cmd

set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_test/sv ../tb/" $tb_name "_test/sv/" $tb_name "_test_pkg.sv"
eval $cmd

set cmd  "vlog -sv -timescale 1ns/1ps +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_tb/sv ../tb/" $tb_name "_tb/sv/" $tb_name "_th.sv"
append cmd " ../tb/" $tb_name "/sv/top_cov.sv"
eval $cmd

set cmd  "vlog -sv -timescale 1ns/1ps +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_tb/sv ../tb/" $tb_name "_tb/sv/" $tb_name "_tb.sv"
eval $cmd
exit
