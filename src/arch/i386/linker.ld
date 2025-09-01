/* OUTPUT_FORMAT(elf32-i386) */
ENTRY(kmain)

INPUT (
    build/kernel/main.o
    
    build/arch/i386/console.o
    build/arch/i386/interrupt.o
)

SECTIONS
{
    . = 0x20000 + SIZEOF_HEADERS;
    .text : { *(.text*) }
    .data : { *(.data*) }
    .bss  : { *(.bss*) }
}