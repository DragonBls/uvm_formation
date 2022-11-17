#include <stdint.h>
#include <stdbool.h>

#include "uvm_sw_ipc.h"


int main(int argc, char *argv[])
{
  uint32_t i;
  uint32_t data;

  uvm_sw_ipc_wait_event(0);

  uvm_sw_ipc_print_info(0, "check fifo data is correct");
  // fifo0
  i = 0;
  while (uvm_sw_ipc_pull_data(0, &data)) {
    if (data != 2*i) {
      uvm_sw_ipc_print_error(2, "[fifo0] expected data=0x%x got data=0x%x instead", 2*i, data);
    }
    i++;
  }
  uvm_sw_ipc_print_info(1, "[fifo0] received %0d data", i);
  // fifo1
  i = 0;
  while (uvm_sw_ipc_pull_data(1, &data)) {
    if (data != 7*i) {
      uvm_sw_ipc_print_error(2, "[fifo1] expected data=0x%x got data=0x%x instead", 2*i, data);
    }
    i++;
  }
  uvm_sw_ipc_print_info(1, "[fifo1] received %0d data", i);

  uvm_sw_ipc_quit();

  return 0;
}
