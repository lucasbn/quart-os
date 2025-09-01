Goal: given a hard drive and some way of writing bytes to that hard drive, how
could I run code on a computer that doesn't have an operating system installed.

---

I want it to be clear that what happens after the computer boots is completely
dependent on the hardware.

The common mechanism is that there's some code stored on your machine that is
loaded and executed immediately when the machine is powered on, and this code
"searches" for more code to load and execute which is (hopefully) stored on a
hard drive, floppy disk, cd, etc.

In my opinion, the implementation details of this are worth digging into for at
least one architecture type. Here, I'm going to walk you through the
implementation details of two different modes: BIOS (for x86) and UEFI (most
modern CPUs).

Why do I think this is worth spending your time on?

- You'll very quickly appreciate the fact that bare-metal programming is very
  different to what you're used to
- You'll spend a good amount of time with gdb, which is the number one most
  useful tool in OS dev
- You'll develop a deep understanding of the very early booting stages of an OS
  which provides a strong foundation for understanding higher-level OS concepts

---

BIOS (qemu-system-i386)

Computer powers on and BIOS loads the first sector (512 bytes) of hda into
0x7c00. 

We can write instructions to this first sector, and they will be executed by the
CPU.

Problem: a sector is only 512 bytes, so we can't write very sophisticated
programs here.

Problem: real mode (?)

---

Some things I want to consider in this:

- Bootloader: getting a hello world kernel
- Interrupts
- Memory management: internal kernel malloc/free
- File-system support (?)
- Running code at different privilege levels (?)