# Simple bootloader that sets up the environment and calls our C main function
.code16                     # We start in 16-bit real mode
.global _start

.section .text
_start:
    # Set up segment registers
    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    
    # Set up stack
    mov $0x7C00, %sp
    
    # Switch to 32-bit protected mode
    cli                     # Disable interrupts
    
    # Load GDT
    lgdt gdt_descriptor
    
    # Enable protected mode
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0
    
    # Far jump to 32-bit code
    ljmp $0x08, $protected_mode

.code32
protected_mode:
    # Set up 32-bit segment registers
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    
    # Set up stack for 32-bit mode
    mov $0x90000, %esp
    
    # Call our C main function
    call main
    
    # If main returns, halt
halt:
    hlt
    jmp halt

# Global Descriptor Table
gdt_start:
    # NULL descriptor
    .quad 0x0000000000000000
    
    # Code segment descriptor
    .quad 0x00CF9A000000FFFF
    
    # Data segment descriptor  
    .quad 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1    # GDT size
    .long gdt_start                  # GDT address

# Pad to 510 bytes and add boot signature
.fill 510 - (. - _start), 1, 0
.word 0xAA55