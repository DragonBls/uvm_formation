# add waves dumped to vsim.wlf
transcript file questa_run
run 0
add wave -recursive "/top_tb/th/*"
run -all

