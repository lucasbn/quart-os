# Makefile for bare-metal x86 program

CC = gcc
AS = as
LD = ld
OBJCOPY = objcopy

CFLAGS = -m32 -ffreestanding -fno-stack-protector -fno-builtin -nostdlib -Wall -Wextra
ASFLAGS = --32
LDFLAGS = -m elf_i386 -T linker.ld

# Object files
OBJS = boot.o main.o

# Default target
all: bootable.img

# Compile C source
main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

# Assemble boot code
boot.o: boot.s
	$(AS) $(ASFLAGS) boot.s -o boot.o

# Link everything together
kernel.bin: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o kernel.elf
	$(OBJCOPY) -O binary kernel.elf kernel.bin

# Create bootable disk image
bootable.img: kernel.bin
	cp kernel.bin bootable.img
	# Pad to at least 1.44MB floppy size
	truncate -s 1440K bootable.img

# Run in QEMU
run: bootable.img
	qemu-system-i386 -drive format=raw,file=bootable.img -serial stdio -no-reboot

# Clean build artifacts
clean:
	rm -f *.o *.bin *.elf *.img

.PHONY: all run clean