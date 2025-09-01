SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ARCH_BUILD_DIR=$SCRIPT_DIR/../build/arch/i386
DISK_DIR=$ARCH_BUILD_DIR/disk.dsk

dd if=/dev/zero of=$DISK_DIR bs=512 count=2880
dd if=$ARCH_BUILD_DIR/bootloader/loader.bin of=$DISK_DIR conv=notrunc
dd if=$ARCH_BUILD_DIR/kernel.bin of=$DISK_DIR conv=notrunc bs=512 seek=256

qemu-system-i386 \
    -hda $DISK_DIR \
    -nographic \
    -monitor null \
    -net none \
    -s -S
