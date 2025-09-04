#include "main.h"
#include "kmalloc.h"
#include <stdint.h>

void kmain() {

    kmalloc_init();
    intr_init();
    serial_init();
    __asm__ volatile ("sti");

    void *ptr = kmalloc(1024);
    if (ptr == NULL) {
        kprint("Failed to allocate 1KB");
    }
    
    void *ptr2 = kmalloc(200 * 1024 * 1024);
    if (ptr2 == NULL) {
        kprint("Failed to allocate 200MB");
    }

    for (;;) {}
}