I want this project to start at the beginning.

We're going to use qemu to emulate a CPU that supports/implements the x86_64
instruction set.

So we have our CPU. The question now becomes: how on earth do we tell the CPU to
execute instructions?

Let's figure this out by diving into qemu internals.

```
cd submodules/qemu
mkdir build
cd build
../configure --target-list=x86_64-softmmu --enable-debug
make
```

You should now have an executable file 'qemu-system-x86_64'. Go ahead an execute
that with './qemu-system-x86_64 -nographic'.

```
SeaBIOS (version rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org)


iPXE (http://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+06FD0FC0+06F30FC0 CA00



Booting from Hard Disk...
Boot failed: could not read the boot disk

Booting from Floppy...
Boot failed: could not read the boot disk

Booting from DVD/CD...
Boot failed: Could not read from CDROM (code 0003)
Booting from ROM...
iPXE (PCI 00:03.0) starting execution...ok
iPXE initialising devices...ok



iPXE 1.20.1+ (g4bd0) -- Open Source Network Boot Firmware -- http://ipxe.org
Features: DNS HTTP iSCSI TFTP AoE ELF MBOOT PXE bzImage Menu PXEXT

net0: 52:54:00:12:34:56 using 82540em on 0000:00:03.0 (open)
  [Link:up, TX:0 TXE:0 RX:0 RXE:0]
Configuring (net0 52:54:00:12:34:56)................. No configuration methods s
ucceeded (http://ipxe.org/040ee119)
No more network devices

No bootable device.
```

We see a few things here that we should take note of:

- SeaBIOS
- 'Booting from X'
- iPXE