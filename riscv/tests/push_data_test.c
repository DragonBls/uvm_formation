#include <stdint.h>
#include <stdbool.h>

#include "uvm_sw_ipc.h"


int main(int argc, char *argv[])
{
  uint32_t i;

  for (i = 0; i < 1024; ++i) {
    uvm_sw_ipc_push_data(0, i);
    uvm_sw_ipc_push_data(1, i*2);
  }
  uvm_sw_ipc_print_info(0, "data has been pushed");
  uvm_sw_ipc_gen_event(0);

  return 0;
}
