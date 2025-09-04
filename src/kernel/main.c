#include "main.h"
#include <stdint.h>

struct e820_entry {
    uint64_t base;
    uint64_t length;
    uint32_t type;
    uint32_t padding;
} __attribute__((packed));

void kmain(struct e820_entry *mmap) {

    intr_init();
    serial_init();

    __asm__ volatile ("sti");

    for (;;) {}
}