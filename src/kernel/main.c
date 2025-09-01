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

    int output = 10 / 0;
    if (output > 0) {
        kprint("\nDivide by zero!");
    }

    kprint("\nLucas was here!");
    for (;;) {}
}