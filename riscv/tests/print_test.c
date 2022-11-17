#include <stdint.h>
#include <stdbool.h>

#include "uvm_sw_ipc.h"


int main(int argc, char *argv[])
{
  uvm_sw_ipc_print_info(0, "start test");

  // args
  for (int i = 0; i < 10; i++) {
    uvm_sw_ipc_print_info(1, "this is an info ; int=%0d", i);
  }
  uvm_sw_ipc_print_info(1, "string args are also supported : str=%s", "this is a string");

  uvm_sw_ipc_print_warning(0, "this is a warning");
  uvm_sw_ipc_print_error(0, "this is an error");
  uvm_sw_ipc_print_fatal(0, "this is a fatal");

  uvm_sw_ipc_quit();
  return 0;
}
