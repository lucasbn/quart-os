#define COM1 0x3f8

int serial_init(void);
char serial_read(void);
void serial_write(char c);