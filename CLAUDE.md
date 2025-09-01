# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an x86 operating system project written in C and assembly. The goal is to understand bare-metal programming and bootloader implementation from first principles. The project builds a bootloader that transitions from 16-bit real mode to 32-bit protected mode and loads a simple kernel.

## Architecture

- **Target**: i386 architecture (32-bit x86)
- **Boot Method**: BIOS-based bootloader (not UEFI)
- **Memory Layout**: Kernel loads at 0x20000, bootloader at 0x7c00
- **Build System**: GNU Make with modular architecture

### Directory Structure

```
src/
├── arch/i386/           # Architecture-specific code
│   ├── bootloader/      # BIOS bootloader in assembly
│   ├── console.c        # Serial I/O implementation
│   └── linker.ld        # Kernel linking script
├── kernel/              # Architecture-independent kernel
│   ├── main.c          # Kernel entry point (kmain)
│   └── main.h          # Kernel headers
scripts/
├── run.sh              # QEMU execution script
build/                  # Build output directory
```

## Build Commands

### Core Build Operations
- `make` - Build the complete kernel binary
- `make clean` - Remove all build artifacts
- `make arch` - Build architecture-specific components only

### Architecture Support
- Default architecture is i386, override with `ARCH=<target>`
- Build output goes to `build/` directory

### Debugging and Testing
- `scripts/run.sh` - Create disk image and launch QEMU with GDB support
  - Uses QEMU's `-s -S` flags for GDB debugging on port 1234
  - Creates 1.4MB disk image with bootloader and kernel
  - Serial output redirected to terminal

## Key Implementation Details

### Boot Process
1. BIOS loads first 512 bytes (MBR) from disk into 0x7c00
2. Bootloader searches partition table for bootable partition (type 0x20)
3. Loads kernel from disk using BIOS interrupt 0x13 (disk I/O)
4. Transitions to 32-bit protected mode with custom GDT
5. Jumps to kernel entry point at address stored at 0x20018

### Memory Management
- Kernel linked to load at 0x20000 + header size
- Stack initialized at 0xf000 during bootloader
- GDT contains null, code (0x08), and data (0x10) segments

### I/O System
- Serial console output via `putchar()` and `kprint()`
- Automatic CR+LF handling for newlines
- No keyboard input implemented yet

## Development Workflow

1. Make changes to source code
2. Run `make` to build kernel binary
3. Use `scripts/run.sh` to test in QEMU
4. Debug with GDB: `gdb` then `target remote localhost:1234`

## Tools and Dependencies
- **Compiler**: GCC with `-m32 -ffreestanding` flags
- **Assembler**: NASM for bootloader assembly
- **Linker**: GNU LD with custom linker script
- **Emulator**: QEMU (qemu-system-i386)
- **Debugger**: GDB for kernel debugging