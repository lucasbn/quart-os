SRC_DIR := src
BUILD_DIR := build
IMAGES_DIR := images

LOADER_SRC := $(SRC_DIR)/loader.asm
LOADER_BIN := $(BUILD_DIR)/loader.bin
PARTITION_BIN := $(BUILD_DIR)/partition-table.bin
DISK_IMG := $(IMAGES_DIR)/disk.dsk

.PHONY: all loader disk run clean

all: disk

$(BUILD_DIR):
	mkdir -p $@

$(IMAGES_DIR):
	mkdir -p $@

$(LOADER_BIN): $(LOADER_SRC) | $(BUILD_DIR)
# 	A binary file for booting with qemu
	nasm -f bin $< -o $@
#   An elf file with debug symbols for gdb
	nasm -f elf32 -g -F dwarf src/loader.asm -o build/loader.o
	ld -m elf_i386 -T loader.ld -o build/loader.elf build/loader.o

$(PARTITION_BIN): scripts/create-partition-table.py | $(BUILD_DIR)
	python3 $< > $@

$(DISK_IMG): $(LOADER_BIN) $(PARTITION_BIN) | $(IMAGES_DIR)
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$(LOADER_BIN) of=$@ conv=notrunc
	dd if=$(PARTITION_BIN) of=$@ conv=notrunc bs=1 seek=446
	dd if=test.bin of=$@ conv=notrunc bs=512 seek=256

disk: $(DISK_IMG)

run: $(DISK_IMG)
	qemu-system-i386 -hda $< -nographic -monitor null -net none
debug: $(DISK_IMG)
	qemu-system-i386 -hda $< -nographic -monitor null -net none -s -S

clean:
	rm -rf $(BUILD_DIR) $(IMAGES_DIR)
