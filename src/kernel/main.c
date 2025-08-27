#include <stdint.h>

static volatile uint16_t* const VGA = (uint16_t*)0xB8000;

void kernel_main(void) {
    const char* s = "hello from C kernel";
    for (int i = 0; s[i]; i++) {
        VGA[i] = (uint16_t)s[i] | (0x07u << 8); // light-grey on black
    }
    for (;;) { __asm__ __volatile__("hlt"); }
}