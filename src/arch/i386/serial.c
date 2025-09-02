#include "serial.h"
#include "interrupt.h"
#include "io.h"

void serial_interrupt_handler(void);

int serial_init(void) {
   outb(COM1 + 1, 0x00);    // Disable all interrupts
   outb(COM1 + 3, 0x80);    // Enable DLAB (set baud rate divisor)
   outb(COM1 + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
   outb(COM1 + 1, 0x00);    //                  (hi byte)
   outb(COM1 + 3, 0x03);    // 8 bits, no parity, one stop bit
   outb(COM1 + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
   outb(COM1 + 4, 0x0B);    // IRQs enabled, RTS/DSR set
   outb(COM1 + 4, 0x1E);    // Set in loopback mode, test the serial chip
   outb(COM1 + 0, 0xAE);    // Test serial chip (send byte 0xAE and check if serial returns same byte)

   // Check if serial is faulty (i.e: not same byte as sent)
   if(inb(COM1 + 0) != 0xAE) {
      return 1;
   }

   // If serial is not faulty set it in normal operation mode
   // (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
   outb(COM1 + 4, 0x0B);    // OUT2 not set, interrupts won't be signaled to PIC
   outb(COM1 + 1, 0x01);    // Enable received data available interrupt

   intr_register_handler(0x24, serial_interrupt_handler);

   return 0;
}

static inline int serial_received() {
   return inb(COM1 + 5) & 1;
}

char serial_read() {
   while (serial_received() == 0);
   return inb(COM1);
}

static inline int is_transmit_empty() {
    return inb(COM1 + 5) & 0x20;
}

void serial_write(char c) {
    while (!is_transmit_empty());
    outb(COM1, c);
}

void serial_interrupt_handler(void) {
    char c = serial_read();
    // Handle the received character (e.g., echo it back)
    serial_write(c);
}