ARCH_ASM_SRCS := boot.asm intr_stubs.asm
ARCH_ASM_OBJS := $(addprefix $(ARCH_BUILD)/,$(ARCH_ASM_SRCS:.asm=.o))

ARCH_C_SRCS := serial.c interrupt.c
ARCH_C_OBJS := $(addprefix $(ARCH_BUILD)/,$(ARCH_C_SRCS:.c=.o))
ARCH_C_DEPS := $(addprefix $(ARCH_BUILD)/,$(ARCH_C_SRCS:.c=.d))

$(ARCH_BUILD)/%.o: $(ARCH_SRC)/%.asm
	@mkdir -p $(dir $@)
	$(AS) -f elf32 -g -F dwarf $< -o $@

$(ARCH_BUILD)/%.o: $(ARCH_SRC)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

-include $(ARCH_C_DEPS)