# Bare Metal x86 Program with Docker

This project creates a simple bare-metal C program that runs directly on QEMU x86 emulator. The program computes 2+2 and outputs the result via UART.

## What it does

- Boots from a custom bootloader
- Switches from 16-bit real mode to 32-bit protected mode
- Initializes UART communication
- Computes 2 + 2 = 4
- Outputs the result via serial port (UART)
- All containerized with Docker for cross-platform compatibility

## Files Structure

```
├── main.c              # Main C program with computation logic
├── boot.s              # Assembly bootloader
├── linker.ld           # Linker script
├── Makefile            # Build configuration
├── Dockerfile          # Container setup
├── docker-compose.yml  # Container orchestration
└── README.md          # This file
```

## Prerequisites

- Docker
- Docker Compose (optional, but recommended)

## Quick Start

### Option 1: Using Docker Compose (Recommended)

1. Clone or create all the files in a directory
2. Run the application:
   ```bash
   docker-compose up --build
   ```

### Option 2: Using Docker directly

1. Build the Docker image:
   ```bash
   docker build -t baremetal-app .
   ```

2. Run the container:
   ```bash
   docker run -it baremetal-app
   ```

## Expected Output

You should see output similar to:
```
Computing 2 + 2...
Result: 4
Program completed successfully!
```

## How it Works

1. **Boot Process**: The `boot.s` assembly file creates a bootloader that:
   - Sets up the initial environment
   - Switches from 16-bit real mode to 32-bit protected mode
   - Sets up a Global Descriptor Table (GDT)
   - Calls the C main function

2. **Main Program**: The `main.c` file:
   - Initializes UART communication on COM1 port
   - Performs the calculation (2 + 2)
   - Converts the result to a string
   - Outputs via UART

3. **QEMU Emulation**: The program runs on QEMU's x86 system emulator with serial output redirected to stdio

## Development

To modify the program:

1. Edit the source files
2. Rebuild and run:
   ```bash
   docker-compose up --build
   ```

## Technical Details

- **Target Architecture**: x86 (32-bit)
- **Boot Method**: Legacy BIOS boot sector
- **Output Method**: UART serial communication (38400 baud)
- **Build Tools**: GCC cross-compiler, GNU binutils
- **Emulator**: QEMU system emulator

## Troubleshooting

- If you see "Permission denied" errors, make sure Docker has the necessary permissions
- On some systems, you might need to run Docker commands with `sudo`
- The container needs privileged mode for QEMU to work properly

## Cross-Platform Compatibility

This setup works on:
- macOS (including M1/M2/M3 Macs)
- Linux
- Windows (with Docker Desktop)

The Docker container handles all the cross-compilation details automatically.