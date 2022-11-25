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
  extern task	       uvm_sw_ipc_gen_event(int event_idx);
  extern task          uvm_sw_ipc_wait_event(int event_idx);
  extern function void uvm_sw_ipc_push_data(input int fifo_idx, input [31:0] data);
  extern function bit  uvm_sw_ipc_pull_data(input int fifo_idx, output [31:0] data);

  uvm_tlm_analysis_fifo#(uvm_sw_ipc_tx) monitor_fifo;
  uvm_sw_ipc_tx 			ipc_tx;
  uvm_event                             event_to_uvm[UVM_SW_IPC_EVENT_NB];
  uvm_event                             event_to_sw[UVM_SW_IPC_EVENT_NB];
  bit [31:0]                            fifo_data_to_uvm[UVM_SW_IPC_FIFO_NB][$];
  bit [31:0]                            fifo_data_to_sw[UVM_SW_IPC_FIFO_NB][$];
  bit [31:0]                            fifo_data_push_to_uvm[UVM_SW_IPC_FIFO_NB][$];
  bit [31:0]				fifo_data_to_sw_empty = 32'hFFFFFFFF;

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
  extern task		 print_info(bit [31:0] cmd);
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
	ipc_tx = uvm_sw_ipc_tx::type_id::create("ipc_tx",this);
	fork
	forever begin
		#1ns
		if (m_quit == 1)
			phase.drop_objection(this);
	end
	forever begin
		@(fifo_data_to_sw_empty);
		vif.backdoor_write(m_config.fifo_data_to_sw_empty_address,fifo_data_to_sw_empty);
	end
	forever begin
		monitor_fifo.get(ipc_tx);
		// `uvm_info("debug info",$sformatf("%s",ipc_tx.convert2string()),UVM_LOW)
		if(ipc_tx.addr inside {[m_config.cmd_address:m_config.fifo_data_to_sw_empty_address]})begin
		case(ipc_tx.addr) inside
			m_config.cmd_address: begin
				case(ipc_tx.data) inside
					32'h1:  m_quit = 1;
					32'h2: begin
						bit [31:0] event_num = fifo_data_to_uvm[0].pop_front();
						if(event_num<UVM_SW_IPC_EVENT_NB)
							event_to_uvm[event_num].trigger(); 
						else
							event_to_sw[event_num-UVM_SW_IPC_EVENT_NB].trigger();
					end
					32'h4: begin//put data in another fifo
						bit [31:0] fifo_num = fifo_data_to_uvm[0].pop_front();
						fifo_data_push_to_uvm[fifo_num].push_back(fifo_data_to_uvm[fifo_num].pop_front());
					end
					32'h5: begin
						int fifo_idx = fifo_data_to_uvm[0].pop_front();
						vif.backdoor_write(m_config.fifo_data_to_sw_address[fifo_idx], fifo_data_to_sw[fifo_idx].pop_front());
						if(fifo_data_to_sw[fifo_idx].size()==0)
							fifo_data_to_sw_empty = fifo_data_to_sw_empty | (1<<fifo_idx);
					end
					[32'h6:32'h9] : print_info(ipc_tx.data);
				endcase
			end
			[m_config.fifo_data_to_uvm_address[0]:m_config.fifo_data_to_uvm_address[UVM_SW_IPC_FIFO_NB-1]]:begin
				fifo_data_to_uvm[(ipc_tx.addr-m_config.fifo_data_to_uvm_address[0])/4].push_back(ipc_tx.data);
			end
			m_config.fifo_data_to_sw_empty_address:
				fifo_data_to_sw_empty = ipc_tx.data;
		endcase
		end
	end
	join_any
endtask : run_phase

task uvm_sw_ipc::uvm_sw_ipc_gen_event(int event_idx);
	event_to_sw[event_idx].wait_trigger();
	vif.backdoor_write(m_config.fifo_data_to_sw_address[0],event_idx);
	vif.backdoor_write(m_config.cmd_address,3);
endtask : uvm_sw_ipc_gen_event

task          uvm_sw_ipc::uvm_sw_ipc_wait_event(int event_idx);
	event_to_uvm[event_idx].wait_trigger();
endtask : uvm_sw_ipc_wait_event

function void uvm_sw_ipc::uvm_sw_ipc_push_data(input int fifo_idx, input [31:0] data);
	fifo_data_to_sw[fifo_idx].push_back(data);
	fifo_data_to_sw_empty = fifo_data_to_sw_empty & ~(1<<fifo_idx);
endfunction : uvm_sw_ipc_push_data

function bit  uvm_sw_ipc::uvm_sw_ipc_pull_data(input int fifo_idx, output [31:0] data);
	data = fifo_data_push_to_uvm[fifo_idx].pop_front();
endfunction : uvm_sw_ipc_pull_data

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


task uvm_sw_ipc::print_info(bit [31:0] cmd);
	string str = vif.backdoor_get_string(fifo_data_to_uvm[0].pop_front());
	string all_str = str_format(str,fifo_data_to_uvm[1]);
	case(cmd)
		32'h6: `uvm_info("sw info",all_str,UVM_LOW)
		32'h7: `uvm_warning("sw_info",all_str)
		32'h8: `uvm_error("sw_info",all_str)
		32'h9: `uvm_fatal("sw_info",all_str)
	endcase
endtask 


`endif // UVM_SW_IPC_SV
