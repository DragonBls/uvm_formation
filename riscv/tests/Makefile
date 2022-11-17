CC=riscv64-unknown-elf-gcc
LD=riscv64-unknown-elf-ld
HEX_CONV32=hexdump -v -e '1/4 "%08x "' -e '"\n"'
OBJCOPY=riscv64-unknown-elf-objcopy

CFLAGS=-mabi=ilp32 -march=rv32i -ffunction-sections -fdata-sections -Iuvm_sw_ipc
LDFLAGS=-Tlink.ld -melf32lriscv -Map=$@.map

SRCS=$(wildcard *.c)
OBJS=$(SRCS:.c=.o) uvm_sw_ipc.o
ELFS=$(SRCS:.c=.elf)
BINS=$(SRCS:.c=.text.bin) $(SRCS:.c=.data.bin)
VHS=$(SRCS:.c=.text.vh) $(SRCS:.c=.data.vh)
MAP=$(SRCS:.c=.elf.map)

all: ${SRCS} ${VHS}

uvm_sw_ipc.o: uvm_sw_ipc/uvm_sw_ipc.c
	${CC} -c ${CFLAGS} -o $@ $<

%.o: %.c
	${CC} -c ${CFLAGS} -o $@ $<

%.elf: %.o uvm_sw_ipc.o
	${LD} ${LDFLAGS} $< -o $@ uvm_sw_ipc.o

%.text.bin: %.elf
	${OBJCOPY} -O binary $< $@ -j .init -j .text -j .rodata --change-addresses -0x400000

%.data.bin: %.elf
	${OBJCOPY} -O binary $< $@ -j .uvm_sw_ipc -j .data -j .eh_frame -j .fini_array -j .init_array --change-addresses -0x80000000

%.vh: %.bin
	${HEX_CONV32} $< > $@

clean:
	rm -f ${OBJS} ${ELFS} ${BINS} ${VHS} ${MAP}
