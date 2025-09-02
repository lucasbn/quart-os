#include <stdint.h>
#include "io.h"

#define PIC0_CTRL	0x20    /* Master PIC control register address. */
#define PIC0_DATA	0x21    /* Master PIC data register address. */
#define PIC1_CTRL	0xa0    /* Slave PIC control register address. */
#define PIC1_DATA	0xa1    /* Slave PIC data register address. */

struct InterruptDescriptor32 {
    uint16_t offset_1;        // offset bits 0..15
    uint16_t selector;        // a code segment selector in GDT or LDT
    uint8_t  zero;            // unused, set to 0
    uint8_t  type_attributes; // gate type, dpl, and p fields
    uint16_t offset_2;        // offset bits 16..31
};

struct __attribute__((packed)) IDTROperand {
    uint16_t limit;
    uint32_t base;
};

static struct InterruptDescriptor32 idt[256];
extern void* isr_stub_table[];

void (*intr_handlers[256])(void);

void pic_init(void)
{
    /* Mask all interrupts on both PICs. */
    outb(PIC0_DATA, 0xff);
    outb(PIC1_DATA, 0xff);

    /* Initialize master. */
    outb(PIC0_CTRL, 0x11); /* ICW1: single mode, edge triggered, expect ICW4. */
    outb(PIC0_DATA, 0x20); /* ICW2: line IR0...7 -> irq 0x20...0x27. */
    outb(PIC0_DATA, 0x04); /* ICW3: slave PIC on line IR2. */
    outb(PIC0_DATA, 0x01); /* ICW4: 8086 mode, normal EOI, non-buffered. */

    /* Initialize slave. */
    outb(PIC1_CTRL, 0x11); /* ICW1: single mode, edge triggered, expect ICW4. */
    outb(PIC1_DATA, 0x28); /* ICW2: line IR0...7 -> irq 0x28...0x2f. */
    outb(PIC1_DATA, 0x02); /* ICW3: slave ID is 2. */
    outb(PIC1_DATA, 0x01); /* ICW4: 8086 mode, normal EOI, non-buffered. */

    /* Unmask all interrupts. */
    outb(PIC0_DATA, 0x00);
    outb(PIC1_DATA, 0x00);
}

void intr_handler(int vector)
{
    if (intr_handlers[vector]) {
        intr_handlers[vector]();
    }

    if (vector >= 0x20 && vector < 0x30) {
        /* Send End of Interrupt (EOI) signal to PICs. */
        outb(PIC0_CTRL, 0x20);
        if (vector >= 0x28) {
            outb(PIC1_CTRL, 0x20);
        }
    }
}

void set_idt_gate(int i, void (*isr_addr)(void))
{
    idt[i] = (struct InterruptDescriptor32) {
        .offset_1 = (uint32_t)isr_addr & 0xFFFF,
        .selector = 0x08,
        .zero = 0,
        .type_attributes = 0x8E,
        .offset_2 = (uint32_t)isr_addr >> 16 & 0xFFFF,
    };
}

void intr_register_handler(int irq, void (*handler)(void))
{
    intr_handlers[irq] = handler;
}

void intr_init(void)
{
    /* Initialise PIC */
    pic_init();

    for (int i = 0; i < 256; i++) {
        set_idt_gate(i, isr_stub_table[i]);
        intr_handlers[i] = 0;
    }

    /* Load IDT register */
    struct IDTROperand idtr_operand = {
        .limit = sizeof(idt) - 1,
        .base = (uint32_t) idt,
    };

    asm volatile ("lidt %0" : : "m" (idtr_operand));
}