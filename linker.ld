/* Linker script for our bare-metal program */

ENTRY(_start)

SECTIONS
{
    /* Boot sector loaded at 0x7C00 */
    . = 0x7C00;
    
    .text : {
        *(.text)
    }
    
    .data : {
        *(.data)
    }
    
    .bss : {
        *(.bss)
    }
}