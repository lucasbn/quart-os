# Use Ubuntu as base image for cross-compilation tools
FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    gcc-multilib \
    binutils \
    make \
    qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy source files
COPY main.c boot.s linker.ld Makefile ./

# Build the bootable image
RUN make clean && make

# Default command runs the program in QEMU
CMD ["make", "run"]