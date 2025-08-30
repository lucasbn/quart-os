OUTPUT_FORMAT(elf32-i386)
ENTRY(kmain)

INPUT (
    build/kernel/main.o
)

SECTIONS
{
    . = 0x20000 + SIZEOF_HEADERS;
    .text : { *(.text*) }
    .data : { *(.data*) }
    .bss  : { *(.bss*) }
}