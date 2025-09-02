extern intr_handler

; This macro is for handling error interrupts
%macro isr_stub_err 1
isr_stub_%+%1:
    push dword %1
    call intr_handler
    add esp, 8
    iret
%endmacro

; This macro is for handling non-error interrupts
%macro isr_stub 1
isr_stub_%+%1:
    push dword 0
    push dword %1
    call intr_handler
    add esp, 8
    iret
%endmacro

; The actual stubs themselves
%assign i 0
%rep 256

%if i == 8 || i == 10 || i == 11 || i == 12 || i == 13 || i == 14 || i == 17 || i == 30
    isr_stub_err i
%else
    isr_stub i
%endif

%assign i i+1
%endrep

align 8

global isr_stub_table
isr_stub_table:
%assign i 0 
%rep    256 
    dd isr_stub_%+i    
%assign i i+1 
%endrep