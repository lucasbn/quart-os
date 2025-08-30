KERNEL_SRCS := main.c
KERNEL_OBJS := $(addprefix $(KERNEL_BUILD)/,$(KERNEL_SRCS:.c=.o))

$(KERNEL_BUILD)/%.o: $(KERNEL_SRC)/%.c
	@mkdir -p $(dir $@)
	$(CC) -g -m32 -ffreestanding -c $< -o $@
