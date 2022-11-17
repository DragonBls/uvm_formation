`ifndef VERIF_UTILS_THREADS_SV
  `define VERIF_UTILS_THREADS_SV


  class verif_utils_threads #(
    parameter ADDR_WIDTH        = 32,
    parameter ALIGNED_ON_N_BITS = 0
  );

    typedef struct {
      bit[ADDR_WIDTH-1:0] addr_min;
      bit[ADDR_WIDTH-1:0] addr_max;
    } thread_struct_t;


    //---------------------------------------------------------
    // members
    //---------------------------------------------------------
    thread_struct_t threads_from_name[string][$]; // filled by create_threads()
    int             thread_nb_from_name[string];
    int             total_thread_nb;
    thread_struct_t minimal_constant_address_space;
    uvm_verbosity   verbosity;


    //---------------------------------------------------------
    // functions
    //---------------------------------------------------------
    function new(
      int thread_nb_from_name[string],
      uvm_verbosity verbosity = UVM_HIGH
    );
      int total;
      total = 0;
      foreach (thread_nb_from_name[str])
        total += thread_nb_from_name[str];
      this.total_thread_nb     = total;
      this.thread_nb_from_name = thread_nb_from_name;
      this.verbosity           = verbosity;
      minimal_init();
    endfunction


    function void create_threads(bit do_print_threads = 1);
      this.constraint_mode(0);
      this.c.constraint_mode(1);
      assert(this.randomize());
      if (do_print_threads) begin
        print_threads();
      end
    endfunction


    function void create_threads_in_minimal_constant_address_space(bit do_print_threads = 1);
      this.constraint_mode(0);
      this.c.constraint_mode(1);
      if (total_thread_nb > 0) begin
        assert(this.randomize() with {
          rand_min[0]                 == minimal_constant_address_space.addr_min;
          rand_max[total_thread_nb-1] == minimal_constant_address_space.addr_max;
        });
        if (do_print_threads) begin
          print_threads();
        end
      end
    endfunction


    function void create_threads_power_of_2_boundaries(bit do_print_threads = 1);
      this.constraint_mode(0);
      this.c.constraint_mode(1);
      this.c_power_of_2_boundaries.constraint_mode(1);
      assert(this.randomize());
      if (do_print_threads) begin
        print_threads();
      end
    endfunction


    function void print_threads();
      foreach (threads_from_name[name])
      begin
        foreach (threads_from_name[name][th])
        begin
          `uvm_info("create_threads", $sformatf("%s__thread_%02d [0x%x:0x%x]",
            name, th,
            threads_from_name[name][th].addr_min,
            threads_from_name[name][th].addr_max), verbosity)
        end
      end
    endfunction


    //---------------------------------------------------------
    // private
    //---------------------------------------------------------
    rand bit[ADDR_WIDTH-1:0] rand_min[$];
    rand bit[ADDR_WIDTH-1:0] rand_max[$];
    rand bit[ADDR_WIDTH-1:0] mask;

    bit is_minimal_init = 0;


    function void minimal_init();
      this.constraint_mode(0);
      is_minimal_init = 1;
      this.c_minimal_init.constraint_mode(1);
      assert(this.randomize());
      is_minimal_init = 0;
      minimal_constant_address_space.addr_min = rand_min[0];
      minimal_constant_address_space.addr_max = rand_max[0];
    endfunction


    constraint c {
      rand_min.size() == total_thread_nb;
      rand_max.size() == total_thread_nb;
      mask == ((1<<ALIGNED_ON_N_BITS) - 1);
      foreach (rand_min[i]) {
        (rand_min[i] & mask) == 0;
        (rand_max[i] & mask) == mask;
        rand_max[i] >= rand_min[i];
        if (i>=1) {
          rand_min[i] > rand_min[i-1];
          rand_min[i] > rand_max[i-1];
        }
      }
    }


    constraint c_minimal_init {
      rand_min.size() == 1;
      rand_max.size() == 1;
      mask == ((1<<ALIGNED_ON_N_BITS) - 1);
      foreach (rand_min[i]) {
        (rand_min[i] & mask) == 0;
        (rand_max[i] & mask) == mask;
      }
      rand_max[0] - rand_min[0] == ((total_thread_nb<<ALIGNED_ON_N_BITS) - 1);
    }


    constraint c_power_of_2_boundaries {
      foreach (rand_min[i]) {
        (rand_max[i] - rand_min[i]) dist {0:=30, 1:=20, 2:=50};
        (
          (rand_min[i]     & (rand_min[i]   - 1)) == 0 ||
          ((rand_min[i]+1) & (rand_min[i]+1 - 1)) == 0 ||
          ((rand_min[i]-1) & (rand_min[i]-1 - 1)) == 0
        );
      }
      foreach (rand_max[i]) {
        (
          (rand_max[i]     & (rand_max[i]   - 1)) == 0 ||
          ((rand_max[i]+1) & (rand_max[i]+1 - 1)) == 0 ||
          ((rand_max[i]-1) & (rand_max[i]-1 - 1)) == 0
        );
      }
    }


    function void post_randomize();
      thread_struct_t threads[$];
      if (!is_minimal_init) begin
        // shuffle addr pairs
        for (int i=0; i<total_thread_nb; i++)
        begin
          thread_struct_t th;
          th.addr_min = rand_min[i];
          th.addr_max = rand_max[i];
          threads.push_back(th);
        end
        threads.shuffle();
        // fill threads_from_name
        foreach (thread_nb_from_name[str])
        begin
          threads_from_name[str] = {};
          for (int i=0; i<thread_nb_from_name[str]; i++)
            threads_from_name[str].push_back(threads.pop_front());
        end
      end
    endfunction

  endclass : verif_utils_threads


`endif
