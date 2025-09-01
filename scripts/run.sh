SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
BOOTLOADER_DIR=$SCRIPT_DIR/../src/arch/i386/bootloader
BOOTLOADER_BUILD_DIR=$BOOTLOADER_DIR/build

ARCH_BUILD_DIR=$SCRIPT_DIR/../build/arch/i386
DISK_DIR=$SCRIPT_DIR/disk.dsk

make -C $SCRIPT_DIR/../src/arch/i386/bootloader

dd if=/dev/zero of=$DISK_DIR bs=512 count=2880
dd if=$BOOTLOADER_BUILD_DIR/loader.bin of=$DISK_DIR conv=notrunc
dd if=$ARCH_BUILD_DIR/kernel.bin of=$DISK_DIR conv=notrunc bs=512 seek=256

qemu-system-i386 \
    -hda $DISK_DIR \
    -nographic \
    -monitor null \
    -net none \
    -s -S
