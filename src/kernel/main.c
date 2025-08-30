extern void serial_write(char c);

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
    kprint("\nLucas was here!");
    for (;;) {}
}