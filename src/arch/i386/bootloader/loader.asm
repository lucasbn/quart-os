[BITS 16]

start:
	sub ax, ax
	mov ds, ax
	mov ss, ax
	mov esp, 0xf000

    ; Make register si point to the start of the partition table
    mov si, 0x7dbe
    mov cx, 4

check_part:
    ; Check if the partition type is 0x20, if not then check the next partition
    cmp byte [si+4], 0x20
    jne next_part

    ; Check if the partition is bootable, if not then check next partition
    cmp byte [si], 0x80
    je load_kernel

next_part:
    ; Move the si register pointer to the next partition table entry
    add si, 16

    ; If we're not yet at the end of the partition table, check the next partition
    loop check_part

    ; If none of the partitions are bootable, tell the BIOS that boot failed
    int 0x18

load_kernel:
	mov ebx, [si+8]
	mov ax, [si+12]

    ; Allocate space for the DAP on the stack (16 bytes)
    push 0
    push 0
    push ebx
    push 0x2000
    push 0
    push ax
    push 16

    ; Prepare the other arguments
    mov si, sp
    mov ah, 0x42
    mov dl, 0x80

    ; Make the BIOS interrupt call
    int 0x13
    jc disk_error

    ; Pop the DAP off the stack
    add sp, 16

    ; Use the BIOS to query about the memory layout
    jmp get_memory_layout

; Handle disk error (error code stored in AH) by informing BIOS that
; the boot failed
disk_error:
    add sp, 16
    int 0x18


; Get a map of the physical memory
get_memory_layout:
    mov ebx, 0
    mov edx, 0x534D4150

    mov ax, 0x5000
    mov di, ax

mem_start:
    mov eax, 0xE820
    mov ecx, 24

    int 0x15
    jc memory_error

    mov [memory_map_entries], di

    ; If ebx is 0 then switch to protected mode
    cmp ebx, 0
    je protected_mode

    ; Increment di by list entry size
    add di, 24

    jmp mem_start

memory_error:    
    int 0x18

protected_mode:
    cli
    xor ax, ax
    mov ds, ax

    ; Enable A20 line
.wait:
    in al, 0x64
    test al, 2
    jnz .wait

    mov al, 0xD1
    out 0x64, al 

.wait2:
    in al, 0x64
    test al, 2
    jnz .wait2

    mov al, 0xDF
    out 0x60, al
    
.wait3:
    in al, 0x64
    test al, 2
    jnz .wait3

    ; Load GDT using absolute 32-bit address
    lgdt [gdt_desc]
    
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    ; Far jump with absolute address
    jmp 0x0008:clear_pipe

[BITS 32]
clear_pipe:
    mov ax, 10h     ; Use data segment selector (0x10)
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ax, [memory_map_entries]

    ; Jump to kernel start code
    jmp 0x200e0

align 8
gdt:
gdt_null:
    dq 0
gdt_code:
    dw 0FFFFh       ; Limit 0-15
    dw 0            ; Base 0-15  
    db 0            ; Base 16-23
    db 10011010b    ; Access byte: Present, Ring 0, Code, Executable, Readable
    db 11001111b    ; Flags + Limit 16-19: 4KB granularity, 32-bit
    db 0            ; Base 24-31

gdt_data:
    dw 0FFFFh       ; Limit 0-15
    dw 0            ; Base 0-15
    db 0            ; Base 16-23  
    db 10010010b    ; Access byte: Present, Ring 0, Data, Writable
    db 11001111b    ; Flags + Limit 16-19: 4KB granularity, 32-bit
    db 0            ; Base 24-31
gdt_end:

gdt_desc:
    dw gdt_end - gdt - 1    ; Limit
    dd gdt                  ; Base address

memory_map_entries:
    dw 0