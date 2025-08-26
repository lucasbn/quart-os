    .code16

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

    ; Jump to kernel
    jmp 0x2000:0x0000

    nop

; Handle disk error (error code stored in AH) by informing BIOS that
; the boot failed
disk_error:
    add sp, 16
    int 0x18