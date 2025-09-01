KERNEL_SRCS := main.c
KERNEL_OBJS := $(addprefix $(KERNEL_BUILD)/,$(KERNEL_SRCS:.c=.o))
KERNEL_DEPS := $(addprefix $(KERNEL_BUILD)/,$(KERNEL_SRCS:.c=.d))

$(KERNEL_BUILD)/%.o: $(KERNEL_SRC)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

-include $(KERNEL_DEPS)