ENTRY(boot_i386)

INPUT (
    build/kernel/main.o
    build/kernel/kmalloc.o
    
    build/arch/i386/boot.o
    build/arch/i386/serial.o
    build/arch/i386/interrupt.o
    build/arch/i386/intr_stubs.o
)

SECTIONS
{
    . = 0x20000 + SIZEOF_HEADERS;
    .text : { *(.text*) }
    .data : { *(.data*) }
    .bss  : { *(.bss*) }
}