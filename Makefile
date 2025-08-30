ARCH           ?= i386

SRC_DIR        := src
KERNEL_SRC	   := $(SRC_DIR)/kernel
ARCH_SRC   := $(SRC_DIR)/arch/$(ARCH)

BUILD          ?= $(abspath build)
KERNEL_BUILD   ?= $(BUILD)/kernel
ARCH_BUILD     ?= $(BUILD)/arch/$(ARCH)

CC = gcc
AS = nasm
LD = ld
LD_MODE = elf_i386

include $(KERNEL_SRC)/Makefile

all: $(ARCH_BUILD)/kernel.bin

arch:
	$(MAKE) -C $(ARCH_SRC) BUILD=$(ARCH_BUILD) CC=$(CC) AS=$(AS) LD=$(LD)

$(ARCH_BUILD)/kernel.bin: $(KERNEL_OBJS) arch
	$(LD) -m $(LD_MODE) -T $(ARCH_SRC)/linker.ld -o $@

clean:
	rm -rf $(BUILD)

