`ifndef VERIF_UTILS_DELAYS_SV
  `define VERIF_UTILS_DELAYS_SV

  function int get_delay(int rate);
    int r;

    if ((rate>100) || (rate<0)) begin
      `uvm_fatal("verif_utils_delays", $sformatf("rate=%0d is invalid.", rate))
    end

    get_delay = 0;
    r = $urandom_range(100, 1);
    while (r>rate)
    begin
      r = $urandom_range(100, 1);
      get_delay++;
    end
  endfunction: get_delay

`endif
