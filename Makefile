ARCH           ?= i386

SRC_DIR        := src
KERNEL_SRC	   := $(SRC_DIR)/kernel
ARCH_SRC       := $(SRC_DIR)/arch/$(ARCH)

BUILD          ?= $(abspath build)
KERNEL_BUILD   ?= $(BUILD)/kernel
ARCH_BUILD     ?= $(BUILD)/arch/$(ARCH)

CC             := i686-elf-gcc
AS             := nasm
LD             := i686-elf-ld

CFLAGS         := -g -ffreestanding -O2 -Wall -MMD -MP

all: $(ARCH_BUILD)/kernel.bin

include $(KERNEL_SRC)/Makefile
include $(ARCH_SRC)/Makefile

$(ARCH_BUILD)/kernel.bin: $(KERNEL_OBJS) $(ARCH_ASM_OBJS) $(ARCH_C_OBJS) 
	$(LD) -T $(ARCH_SRC)/linker.ld -o $@

clean:
	rm -rf $(BUILD)

