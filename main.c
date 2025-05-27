// Simple bare-metal program to compute 2+2 and output via UART
// This runs directly on x86 hardware without an operating system

// UART port addresses for COM1
#define UART_BASE 0x3F8
#define UART_DATA (UART_BASE + 0)
#define UART_LINE_STATUS (UART_BASE + 5)

// Function to write a byte to a port
static inline void outb(unsigned short port, unsigned char data) {
    __asm__ volatile ("outb %0, %1" : : "a"(data), "Nd"(port));
}

// Function to read a byte from a port
static inline unsigned char inb(unsigned short port) {
    unsigned char data;
    __asm__ volatile ("inb %1, %0" : "=a"(data) : "Nd"(port));
    return data;
}

// Initialize UART
void uart_init() {
    outb(UART_BASE + 1, 0x00);    // Disable all interrupts
    outb(UART_BASE + 3, 0x80);    // Enable DLAB (set baud rate divisor)
    outb(UART_BASE + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
    outb(UART_BASE + 1, 0x00);    //                  (hi byte)
    outb(UART_BASE + 3, 0x03);    // 8 bits, no parity, one stop bit
    outb(UART_BASE + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
    outb(UART_BASE + 4, 0x0B);    // IRQs enabled, RTS/DSR set
}

// Send a character via UART
void uart_putchar(char c) {
    // Wait for transmit holding register to be empty
    while ((inb(UART_LINE_STATUS) & 0x20) == 0);
    outb(UART_DATA, c);
}

// Send a string via UART
void uart_puts(const char* str) {
    while (*str) {
        uart_putchar(*str++);
    }
}

// Convert integer to string
void int_to_string(int num, char* str) {
    if (num == 0) {
        str[0] = '0';
        str[1] = '\0';
        return;
    }
    
    int i = 0;
    int is_negative = 0;
    
    if (num < 0) {
        is_negative = 1;
        num = -num;
    }
    
    // Extract digits in reverse order
    while (num != 0) {
        str[i++] = (num % 10) + '0';
        num = num / 10;
    }
    
    if (is_negative) {
        str[i++] = '-';
    }
    
    str[i] = '\0';
    
    // Reverse the string
    int len = i;
    for (int j = 0; j < len / 2; j++) {
        char temp = str[j];
        str[j] = str[len - 1 - j];
        str[len - 1 - j] = temp;
    }
}

// Main function - entry point of our bare-metal program
void main() {
    // Initialize UART
    uart_init();
    
    // Compute 2 + 2
    int a = 2;
    int b = 2;
    int result = a + b;
    
    // Convert result to string
    char result_str[12];
    int_to_string(result, result_str);
    
    // Output the computation
    uart_puts("Computing 2 + 2...\r\n");
    uart_puts("Result: ");
    uart_puts(result_str);
    uart_puts("\r\n");
    uart_puts("Program completed successfully!\r\n");
    
    // Halt the processor
    while (1) {
        __asm__ volatile ("hlt");
    }
}