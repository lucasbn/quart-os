#include "main.h"

void putchar(char c) {
    if (c == '\n') serial_write('\r');
    serial_write(c);
}

void kprint(const char* str)
{
    while (*str) 
    {
        putchar(*str++);
    }
}

void kmain(void) {
    intr_init();

    __asm__ volatile ("int $0x0");

    kprint("\nLucas was here!");
    for (;;) {}
}