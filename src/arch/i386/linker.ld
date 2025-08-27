ENTRY(start)

SECTIONS
{
    . = 0x20000 + SIZEOF_HEADERS;
    .text : { *(.text*) }
    .data : { *(.data*) }
    .bss  : { *(.bss*) }

    /* Do not discard debug info */
    /* Keep .debug_info, .debug_line, etc. */
}