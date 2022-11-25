#include <stdarg.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

#include "uvm_sw_ipc.h"


static volatile spy_st uvm_sw_ipc __attribute__ ((section (".uvm_sw_ipc")));

// TODO: implement uvm_sw_ipc_* functions
void uvm_sw_ipc_quit(void){
	uvm_sw_ipc.cmd = 1;
}

void uvm_sw_ipc_print_info(uint32_t arg_cnt, char const *const str,  ...){
	int data_idx = 1;

	va_list argp;
	va_start (argp,str);

	uvm_sw_ipc.fifo_data_to_uvm[0]= str;

	while(arg_cnt > 0){
		uint32_t tmp = (uint32_t) va_arg(argp,int);
		uvm_sw_ipc.fifo_data_to_uvm[1] = tmp;
		arg_cnt--;
	}
	uvm_sw_ipc.cmd = 6;
}
void uvm_sw_ipc_gen_event(uint32_t event_idx){
	uvm_sw_ipc.fifo_data_to_uvm[0] = event_idx;
	uvm_sw_ipc.cmd = 2;
}
void uvm_sw_ipc_wait_event(uint32_t event_idx){
	uvm_sw_ipc_gen_event(event_idx + 1024);
	while(uvm_sw_ipc.cmd != 3 || uvm_sw_ipc.fifo_data_to_sw[0]!=event_idx);
}

void uvm_sw_ipc_push_data(uint32_t fifo_idx, uint32_t data){
	uvm_sw_ipc.fifo_data_to_uvm[0] = fifo_idx;
	uvm_sw_ipc.fifo_data_to_uvm[fifo_idx] = data;
	uvm_sw_ipc.cmd = 4;
}

bool uvm_sw_ipc_pull_data(uint32_t fifo_idx, uint32_t *data){
	if((uvm_sw_ipc.fifo_data_to_sw_empty<<(31-fifo_idx))>>31 == 0){
		uvm_sw_ipc.fifo_data_to_uvm[0] = fifo_idx;
		uvm_sw_ipc.cmd = 5;
		*data = uvm_sw_ipc.fifo_data_to_sw[fifo_idx];
		return 1;
	} else {
		return 0;
	}
}

void uvm_sw_ipc_print_warning(uint32_t arg_cnt, char const *const str,  ...){
	int data_idx = 1;

	va_list argp;
	va_start (argp,str);

	uvm_sw_ipc.fifo_data_to_uvm[0]= str;

	while(arg_cnt > 0){
		uint32_t tmp = (uint32_t) va_arg(argp,int);
		uvm_sw_ipc.fifo_data_to_uvm[1] = tmp;
		arg_cnt--;
	}
	uvm_sw_ipc.cmd = 7;
}

void uvm_sw_ipc_print_error(uint32_t arg_cnt, char const *const str,  ...){
	int data_idx = 1;

	va_list argp;
	va_start (argp,str);

	uvm_sw_ipc.fifo_data_to_uvm[0]= str;

	while(arg_cnt > 0){
		uint32_t tmp = (uint32_t) va_arg(argp,int);
		uvm_sw_ipc.fifo_data_to_uvm[1] = tmp;
		arg_cnt--;
	}
	uvm_sw_ipc.cmd = 8;
}

void uvm_sw_ipc_print_fatal(uint32_t arg_cnt, char const *const str,  ...){
	int data_idx = 1;

	va_list argp;
	va_start (argp,str);

	uvm_sw_ipc.fifo_data_to_uvm[0]= str;

	while(arg_cnt > 0){
		uint32_t tmp = (uint32_t) va_arg(argp,int);
		uvm_sw_ipc.fifo_data_to_uvm[1] = tmp;
		arg_cnt--;
	}
	uvm_sw_ipc.cmd = 9;
}

