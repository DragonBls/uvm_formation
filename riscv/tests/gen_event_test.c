#include <stdint.h>
#include <stdbool.h>

#include "uvm_sw_ipc.h"


int main(int argc, char *argv[])
{
  uint32_t i;

  for (i = 0; i < 1024; ++i) {
    uvm_sw_ipc_print_info(1, "uvm_sw_ipc_gen_event(%0d)", i);
    uvm_sw_ipc_gen_event(i);
  }

  return 0;
}
