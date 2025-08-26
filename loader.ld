ENTRY(start)

SECTIONS
{
    . = 0x7C00;
    .text : { *(.text*) }
    .data : { *(.data*) }
    .bss  : { *(.bss*) }

    /* Do not discard debug info */
    /* Keep .debug_info, .debug_line, etc. */
}