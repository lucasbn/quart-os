extern int serial_init(void);
extern void serial_write(char c);
extern void intr_init(void);

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