BUILD            := build
PARTITION_SCRIPT := scripts/create-partition-table.py
AS               := nasm
LD               := i686-elf-ld

.PHONY: all

all: $(BUILD)/loader.bin

$(BUILD)/loader.o: loader.asm
	@mkdir -p $(dir $@)
	$(AS) -f elf32 -g -F dwarf $< -o $@

$(BUILD)/loader.elf: $(BUILD)/loader.o loader.ld
	@mkdir -p $(dir $@)
	$(LD) -T loader.ld -o $@ $<

$(BUILD)/loader.bin: $(BUILD)/loader.elf $(PARTITION_SCRIPT)
	@mkdir -p $(dir $@)
	i686-elf-objcopy -O binary $< $@
	python3 $(PARTITION_SCRIPT) | dd of=$@ bs=1 seek=446 conv=notrunc