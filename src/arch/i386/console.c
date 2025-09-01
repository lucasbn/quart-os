#include "io.h"

static inline int is_transmit_empty() {
    // __asm__ volatile("nop");
    return inb(COM1 + 5) & 0x20;
}

void serial_write(char c) {
    while (!is_transmit_empty());
    outb(COM1, c);
}