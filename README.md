Goal: given a hard drive and some way of writing bytes to that hard drive, how
could I run code on a computer that doesn't have an operating system installed.

Computer powers on and BIOS loads the first sector (512 bytes) of hda into
0x7c00. 

We can write instructions to this first sector, and they will be executed by the
CPU.

Problem: a sector is only 512 bytes, so we can't write very sophisticated
programs here.

Problem: real mode (?)