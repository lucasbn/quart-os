    .code16

start:
    mov ax, 0x07C0       ; set up segment registers
    mov ds, ax
    mov es, ax
    xor bx, bx           ; ES:BX = 0000:0000 buffer
    mov dl, 0x80         ; BIOS disk 0x80 = first hard disk

    ; Make register si point to the start of the partition table
    mov si, 0x01BE
    mov cx, 4

check_part:
    ; Check if the partition type is 0x01, if not then check the next partition
    cmp byte [si+4], 0x01
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
    call    puts
    db      0x0d, "Loading kernel...", 0x0d, 0

    ; We know the partition has 128 sectors each of which are 512 bytes, so lets
    ; just 

hang:
    jmp hang

; --------------------

puts:
    xchg    si, [ss:esp]        ; Get return address (string pointer) into SI
    push    ax                  ; Save AX
.next_char:
    mov     al, [cs:si]         ; Load character from code segment
    inc     si                  ; Advance string pointer
    test    al, al              ; Test for null terminator
    jz      .done               ; Jump if null (end of string)
    call    putc                ; Print character
    jmp     .next_char          ; Continue with next character
.done:
    pop     ax                  ; Restore AX
    xchg    si, [ss:esp]        ; Put updated return address back
    ret                         ; Return to byte after null terminator
putc:
    pusha                       ; Save all general-purpose registers
    
    sub     bh, bh              ; Page 0
    mov     ah, 0x0e            ; Teletype output service
    int     0x10                ; BIOS video interrupt
    
    cmp     al, 0x0d            ; Check for carriage return
    jne     .exit               ; Not CR, we're done
    mov     al, 0x0a            ; Load line feed character
    mov     ah, 0x0e            ; Teletype output service again
    int     0x10                ; Output the line feed
    
.exit:
    popa                        ; Restore all general-purpose registers
    ret                         ; Return to caller
