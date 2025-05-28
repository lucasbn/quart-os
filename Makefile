all: boot.asm
	nasm -f bin boot.asm -o boot.img

run:
	qemu-system-x86_64 -drive format=raw,file=boot.img -nographic