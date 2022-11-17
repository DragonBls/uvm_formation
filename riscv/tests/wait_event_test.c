#include <stdint.h>
#include <stdbool.h>

#include "uvm_sw_ipc.h"


int main(int argc, char *argv[])
{
  uint32_t i;

  for (i = 0; i < 1024; ++i) {
    uvm_sw_ipc_wait_event(i);
    uvm_sw_ipc_print_info(1, "uvm_sw_ipc_wait_event(%0d) done", i);
  }

  uvm_sw_ipc_print_info(0, "all events were received");
  uvm_sw_ipc_quit();
  return 0;
}
