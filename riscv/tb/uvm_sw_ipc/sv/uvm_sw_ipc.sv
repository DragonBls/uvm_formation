`ifndef UVM_SW_IPC_SV
`define UVM_SW_IPC_SV


class uvm_sw_ipc extends uvm_component;

  `uvm_component_utils(uvm_sw_ipc)

  // ___________________________________________________________________________________________
  //             C-side                              |              UVM-side        
  // ________________________________________________|__________________________________________
  // ...                                             |      uvm_sw_ipc_wait_event(0) waits
  // uvm_sw_ipc_gen_event(0)                      ---|-->   uvm_sw_ipc_wait_event(0) returns
  //                                                 |
  // uvm_sw_ipc_wait_event(16) waits                 |      ...
  // uvm_sw_ipc_wait_event(16) returns            <--|---   uvm_sw_ipc_gen_event(16)
  //
  // uvm_sw_ipc_push_data(0, 0xdeadbeef)          ---|-->   uvm_sw_ipc_pull_data(0, data)
  //                                                 |
  // uvm_sw_ipc_pull_data(1 , &data)              <--|---   uvm_sw_ipc_push_data(1, data)
  //                                                 |
  // uvm_sw_ipc_print_info(1, "data=0x%0x", data) ---|-->   `uvm_info(...)
  //                                                 |
  // uvm_sw_ipc_quit()                            ---|-->   end of simulation

  // high-level API
  extern function void uvm_sw_ipc_gen_event(int event_idx);
  extern task          uvm_sw_ipc_wait_event(int event_idx);
  extern function void uvm_sw_ipc_push_data(input int fifo_idx, input [31:0] data);
  extern function bit  uvm_sw_ipc_pull_data(input int fifo_idx, output [31:0] data);

  uvm_tlm_analysis_fifo#(uvm_sw_ipc_tx) monitor_fifo;
  uvm_event                             event_to_uvm[UVM_SW_IPC_EVENT_NB];
  uvm_event                             event_to_sw[UVM_SW_IPC_EVENT_NB];
  bit [31:0]                            fifo_data_to_uvm[UVM_SW_IPC_FIFO_NB][$];
  bit [31:0]                            fifo_data_to_sw[UVM_SW_IPC_FIFO_NB][$];

  uvm_sw_ipc_config       m_config;
  uvm_sw_ipc_monitor      m_monitor;
  virtual uvm_sw_ipc_if   vif;

  bit                     m_quit = 0;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern function string str_replace(string str, string pattern, string replacement);
  extern function string str_format(string str, ref bit [31:0] q[$]);
  extern function string str_format_one_arg(string str, bit [31:0] arg, bit fmt_is_string);
endclass : uvm_sw_ipc


function  uvm_sw_ipc::new(string name, uvm_component parent);
  super.new(name, parent);
  monitor_fifo = new("monitor_fifo", this);
  foreach (event_to_uvm[i]) begin
    event_to_uvm[i] = new($sformatf("event_to_uvm_%d", i));
    event_to_sw[i] = new($sformatf("event_to_sw_%d", i));
  end
endfunction : new


function void uvm_sw_ipc::build_phase(uvm_phase phase);
  if (!uvm_config_db #(uvm_sw_ipc_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "uvm_sw_ipc config not found")

  m_monitor = uvm_sw_ipc_monitor::type_id::create("m_monitor", this);
endfunction : build_phase


function void uvm_sw_ipc::connect_phase(uvm_phase phase);
  if (m_config.vif == null)
    `uvm_warning(get_type_name(), "uvm_sw_ipc virtual interface is not set!")

  vif                = m_config.vif;
  m_monitor.vif      = m_config.vif;
  m_monitor.m_config = m_config;
  m_monitor.analysis_port.connect(monitor_fifo.analysis_export);
endfunction : connect_phase


// TODO: implement high-level API


task uvm_sw_ipc::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  // TODO: proccess monitor_fifo
  phase.drop_objection(this);
endtask : run_phase




function string uvm_sw_ipc::str_replace(string str, string pattern, string replacement);
  string s;
  int p_len;
  s = "";
  p_len = pattern.len();
  foreach (str[i]) begin
    s = {s, str[i]};
    if (s.substr(s.len()-p_len,s.len()-1) == pattern) begin
      s = {s.substr(0, s.len()-p_len-1), replacement};
    end
  end
  return s;
endfunction


function string uvm_sw_ipc::str_format(input string str, ref bit [31:0] q[$]);
  string s;
  bit fmt_start;
  int fmt_cnt;
  bit fmt_is_string;

  str = str_replace(str, "%%", "__pct__");

  fmt_start = 0;
  s = "";
  foreach (str[i]) begin
    s = {s, str[i]};
    case (str[i])
      "%", " ", "\t", "\n": begin
        if (fmt_start && fmt_cnt > 0) begin
          s = str_format_one_arg(s, q.pop_front(), fmt_is_string);
        end
        fmt_start = (str[i] == "%");
        fmt_cnt = 0;
        fmt_is_string = 0;
      end
      default: begin
        fmt_cnt ++;
        if (str[i] == "s") begin
          fmt_is_string = 1;
        end
      end
    endcase
  end
  if (fmt_start && fmt_cnt > 0) begin
    s = str_format_one_arg(s, q.pop_front(), fmt_is_string);
  end

  s = str_replace(s, "__pct__", "%");
  return s;
endfunction


function string uvm_sw_ipc::str_format_one_arg(input string str, bit [31:0] arg, bit fmt_is_string);
  if (fmt_is_string) begin
    str = $sformatf(str, vif.backdoor_get_string(arg));
  end
  else begin
    str = $sformatf(str, arg);
  end
  return str;
endfunction


`endif // UVM_SW_IPC_SV
