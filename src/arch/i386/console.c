#define COM1 0x3F8

static inline void outb(unsigned short port, unsigned char val) {
    __asm__ volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline unsigned char inb(unsigned short port) {
    unsigned char ret;
    __asm__ volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static inline int is_transmit_empty() {
    return inb(COM1 + 5) & 0x20;
}

void serial_write(char c) {
    while (!is_transmit_empty());
    outb(COM1, c);
}