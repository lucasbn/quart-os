#include "main.h"

void kmain(void) {
    intr_init();
    serial_init();

    __asm__ volatile ("sti");

    for (;;) {}
}