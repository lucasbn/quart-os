#include "main.h"

void kmain(void) {
    intr_init();

    __asm__ volatile ("sti");
    // __asm__ volatile ("int $0x21");

    for (;;) {}
}