# uvm_training - fifo
Learn how to build a complete UVM IP-level testbench in 3 weeks

![](https://www.chipverify.com/images/uvm/tb_top.png)



# Agenda
## I- Prerequisites
### week1 day1 to day3
  - create a [github](https://github.com) account
  - brush-up on object oriented programming: [try this](https://datascientest.com/programmation-orientee-objet-guide-ultime)
  - brush-up on bash scripting: [try this](https://www.learnshell.org/)


## II- Theoretical Training
### week1 day4
  - 00_OOP
  - 01_intro_verif_uvm
  - 02_uvm_xaction_constraints_messsaging_uvm_factory

### week1 day5
  - 2bis_interface
  - 03_driver_sequencer

### week2 day1
  - 03_driver_sequncer
  - 04_uvm_monitor_coverage

### week2 day2
  - 05_uvm_agent_et_env
  - 06_uvm_scoreboard

### week2 day3
  - 07_configuration_class
  - 08_virtual_sequencer
  - 09_uvm_test_and_top_testbench

### week2 day4
  - 10_SVA_assertions

### week2 day5
  - Q&A


## III- Practical Case Study: Fifo
  - [populate your git repo](https://github.com/antoinemadec/uvm_training#how-to-copy-the-repo) 
### week3 day1
  - easier UVM
      1. here is the [reference guide](https://www.doulos.com/knowhow/systemverilog/uvm/easier-uvm/easier-uvm-code-generator/easier-uvm-code-generator-reference-guide/)
      2. in **./fifo**, create a template for each agent named **fifo_in** and **fifo_out**
          - defining a good sequence_item is very important
          - use wires in the interface. This is why: [link1](https://verificationacademy.com/forums/systemverilog/wire-vs.-logic-sv-interface) and [link2](https://blogs.sw.siemens.com/verificationhorizons/2013/05/03/wire-vs-reg/)
              > Any signal with more or the potential for more than one driver should be declared as a wire.
          - add the following in your agent's templates
              ```sh
              # needed to have better driver/monitor template
              driver_inc = dummy.sv inline
              monitor_inc = dummy.sv inline

              ```
      3. create a pinlist
      4. generate code with **./gen**
      5. look at the code, Q&A
      6. make sure it compiles with **./run**
          - comment out do_mon() in monitors for now
          - comment out do_drive() in drivers for now

### week3 day2
  1. add the following in **top_tb.sv** to dump all wavesforms
      ```verilog
      `ifdef XCELIUM
        // dump all waveforms (xrun specific)
        initial
        begin
          $shm_open("waves.shm");
          $shm_probe("ACMTF");
        end
      `endif
      ```
  2. interface: use [clocking blocks](https://www.doulos.com/knowhow/systemverilog/systemverilog-tutorials/systemverilog-clocking-tutorial), make sure it compiles
  3. monitor & driver: fill out **do_mon()** and **do_drive()**, make sure it compiles
  4. sequence
      - definition: "virtual sequence = sequence launching other sequences"
      - discussion: virtual sequence is called from the uvm_env, can also be called from the uvm_test

### week3 day3
  1. scoreboard
      1. read this [webpage](http://www.testbench.in/UL_11_PHASE_8_SCOREBOARD.html)
      2. create a scoreboard for your 2 agents
      3. connect the scoreboard to the monitors in the uvm_env
  2. add delays in the drivers
      1. discussion: no delay = lack of coverage
      2. discussion: rate vs delay
      3. look at **./verif_utils/verif_utils_delays.sv**
      4. modify your sequence_items and drivers
  3. drive data to X when it is not supposed to be read by the DUT

### week3 day4
  - assertions
      - discussion: immediate vs concurrent assertions
      - for more info, try [this website](https://www.doulos.com/knowhow/systemverilog/systemverilog-tutorials/systemverilog-assertions-tutorial)
  - code coverage
      - makes sure all the DUT was exercised
      - costs no time
  - functional coverage
      - makes sure all the expected functional corners were hit
      - only useful for random simulations (IP level simulations)
      - for more info, try [this website](https://www.chipverify.com/systemverilog/systemverilog-functional-coverage)
      - note that concurrent assertions can be used for functional coverage
  1. use **run_cov** to run your simulation with coverage
  2. use IMC to look at the code/functional coverage
  3. add a cover group or a cover property checking that the fifo went
      - full->empty->full
      - empty->full->empty
  4. discussion: IP-level vs top-level verification
      - IP-level: random tests, 100% code+functional coverage
      - top-level: directed tests, only code coverage (toggle coverage on IOs)

### week3 day5
  1. resources & discussion
      - fork
        - look at [this website](https://verificationguide.com/systemverilog/systemverilog-fork-join/)
        - join join_any join_none
        - disable fork, wait fork
      - pipelined protocols
          - use [get() and put()](https://www.chipverify.com/uvm/driver-using-get-and-put) instead of [get_next_item() and item_done()](https://www.chipverify.com/uvm/uvm-using-get-next-item)
          - see example [here](https://github.com/antoinemadec/doc/blob/master/uvm.txt#L317)
      - override
          - usually done in the uvm_test
          - can override by type or by instance
          - can be used for error injection etc
  2. Q&A



# Tools
## Xcelium
```sh
# waveforms
simvision waves.shm

# coverage metrics
imc
```

## Questa
```sh
# waveforms
vsim vsim.wlf

# coverage metrics
vsim -viewcov cov_db:top_test
```
