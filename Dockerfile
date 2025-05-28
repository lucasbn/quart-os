FROM ubuntu:25.10

RUN apt-get update && apt-get install -y \
    nasm \
    gcc \
    make \
    qemu-system \
    git \
    libc6-dev \
    ninja-build \
    pkg-config \
    libglib2.0-dev \
    gdb \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY boot.asm ./

CMD ["sleep", "infinity"]