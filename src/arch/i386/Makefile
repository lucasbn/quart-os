AS = nasm
LD = ld

ASM_SRCS := start.asm
ASM_SRCS += bootloader/loader.asm
ASM_OBJS := $(addprefix $(BUILD_DIR)/,$(ASM_SRCS:.asm=.o))

PARTITION_SCRIPT := bootloader/scripts/create-partition-table.py

.PHONY: all

all: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/bootloader/loader.o: bootloader/loader.asm bootloader/loader.ld
	@mkdir -p $(dir $@)
	$(AS) -f elf32 -g -F dwarf $< -o $@
	$(LD) -m elf_i386 -T bootloader/loader.ld -o $(BUILD_DIR)/bootloader/loader.elf $@

$(BUILD_DIR)/%.o: %.asm
	@mkdir -p $(dir $@)
	$(AS) -f elf32 -g -F dwarf $< -o $@

$(BUILD_DIR)/start.elf: $(BUILD_DIR)/start.o
	@mkdir -p $(dir $@)
	$(LD) -m elf_i386 -T linker.ld -o $@ $(BUILD_DIR)/start.o

# First sector, contains custom bootloader and partition table
$(BUILD_DIR)/bootloader/loader.bin: bootloader/loader.asm $(BUILD_DIR)/bootloader/loader.o $(PARTITION_SCRIPT)
	@mkdir -p $(dir $@)
	$(AS) -f bin $< -o $@
	python3 $(PARTITION_SCRIPT) | dd of=$@ bs=1 seek=446 conv=notrunc

# Main kernel binary
$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/start.elf $(BUILD_DIR)/bootloader/loader.bin
	cat $(BUILD_DIR)/start.elf > $@