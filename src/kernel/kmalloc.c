#include <stdint.h>
#include "kmalloc.h"

struct kmalloc_allocator {
    uint32_t fbase;
    uint32_t ftop;
};

static struct kmalloc_allocator kallocator;

void kmalloc_init()
{
    kallocator.fbase = 0x00100000;
    kallocator.ftop = 0x07fe0000;
    return;
}

// size in bytes
void *kmalloc(size_t size)
{
    if (size == 0) {
        return NULL;
    }

    if (kallocator.fbase + size < kallocator.ftop) {
        // Allocate memory
        void *ptr = (void *)kallocator.fbase;
        kallocator.fbase += size;
        return ptr;
    }

    // Handle error, not enough memory
    return NULL;
}