BITS 16
ORG 0x7C00

start:
    mov si, message

print_loop:
    lodsb
    cmp al, 0
    je halt
    mov ah, 0x0E
    int 0x10
    jmp print_loop

halt:
    hlt
    jmp halt

message:
    db "Hello, World!", 0

times 510 - ($ - $$) db 0
dw 0xAA55
