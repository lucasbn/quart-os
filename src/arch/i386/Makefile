ASM_SRCS := $(wildcard src/*.asm)
ASM_SRCS += bootloader/loader.asm
ASM_OBJS := $(addprefix $(BUILD)/,$(ASM_SRCS:.asm=.o))

C_SRCS := console.c
C_OBJS := $(addprefix $(BUILD)/,$(C_SRCS:.c=.o))

PARTITION_SCRIPT := bootloader/scripts/create-partition-table.py

.PHONY: all

all: $(ASM_OBJS) $(C_OBJS) $(BUILD)/bootloader/loader.bin

$(BUILD)/%.o: %.asm
	@mkdir -p $(dir $@)
	$(AS) -f elf32 -g -F dwarf $< -o $@

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -g -m32 -ffreestanding -c $< -o $@

# ---------------------------------------------------------------------------

# Bootloader targets
# TODO: Move into bootloader/ subdir
$(BUILD)/bootloader/loader.elf: $(BUILD)/bootloader/loader.o bootloader/loader.ld
	@mkdir -p $(dir $@)
	$(LD) -m elf_i386 -T bootloader/loader.ld -o $@ $<

$(BUILD)/bootloader/loader.bin: $(BUILD)/bootloader/loader.elf $(PARTITION_SCRIPT)
	@mkdir -p $(dir $@)
	objcopy -O binary $< $@
	python3 $(PARTITION_SCRIPT) | dd of=$@ bs=1 seek=446 conv=notrunc