#include <stdint.h>
#include <stdbool.h>

#include "uvm_sw_ipc.h"


int main(int argc, char *argv[])
{
  uint32_t data_arr[2];
  uint32_t data;
  uint32_t i;

  uvm_sw_ipc_print_info(1, "gen event 0x%0x", 16);
  uvm_sw_ipc_gen_event(16);

  uvm_sw_ipc_print_info(0, "wait event 1");
  uvm_sw_ipc_wait_event(1);
  i = 0;
  while (uvm_sw_ipc_pull_data(0, &data)) {
    data_arr[i] = data;
    i++;
  }
  uvm_sw_ipc_push_data(0, data_arr[0]);
  uvm_sw_ipc_push_data(0, data_arr[1]);
  uvm_sw_ipc_gen_event(0);

  uvm_sw_ipc_print_warning(0, "bye bye");
  uvm_sw_ipc_quit();
  return 0;
}
