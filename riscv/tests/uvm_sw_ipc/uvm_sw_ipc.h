#ifndef UVM_SW_IPC_H
#define UVM_SW_IPC_H


#include <stdarg.h>
#include <stdint.h>
#include <stdbool.h>


// UVM_SW_IPC_DATA_FIFO_NB data fifo + 1 cmd args fifo
#define UVM_SW_IPC_DATA_FIFO_NB 2
#define UVM_SW_IPC_FIFO_NB (UVM_SW_IPC_DATA_FIFO_NB + 1)


// low-level API
typedef struct {
  uint32_t cmd;
  uint32_t fifo_data_to_uvm[UVM_SW_IPC_FIFO_NB]; // write: push in   fifo_data_to_uvm[k]
  uint32_t fifo_data_to_sw[UVM_SW_IPC_FIFO_NB];  // read:  pull from fifo_data_to_sw[k]
  uint32_t fifo_data_to_sw_empty;                // [k]:   fifo_data_to_sw[k] is empty
} spy_st;


// high-level API
void uvm_sw_ipc_quit(void);
void uvm_sw_ipc_gen_event(uint32_t event_idx);
void uvm_sw_ipc_wait_event(uint32_t event_idx);
void uvm_sw_ipc_push_data(uint32_t fifo_idx, uint32_t data);
bool uvm_sw_ipc_pull_data(uint32_t fifo_idx, uint32_t *data);
void uvm_sw_ipc_print_info(uint32_t arg_cnt, char const *const str,  ...);
void uvm_sw_ipc_print_warning(uint32_t arg_cnt, char const *const str,  ...);
void uvm_sw_ipc_print_error(uint32_t arg_cnt, char const *const str,  ...);
void uvm_sw_ipc_print_fatal(uint32_t arg_cnt, char const *const str,  ...);


#endif
