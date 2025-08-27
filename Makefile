ARCH           ?= i386

BUILD_DIR      ?= $(abspath build)
ARCH_BUILD_DIR ?= $(BUILD_DIR)/arch/$(ARCH)

SRC_DIR        := src
ARCH_SRC_DIR   := $(SRC_DIR)/arch/$(ARCH)

CC = gcc

C_SRCS := $(wildcard $(SRC_DIR)/kernel/*.c)
C_OBJS := $(patsubst $(SRC_DIR)/%, $(BUILD_DIR)/%, $(C_SRCS:.c=.o))

.PHONY: all clean

all: $(C_OBJS)
	$(MAKE) -C $(ARCH_SRC_DIR) BUILD_DIR=$(ARCH_BUILD_DIR)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)
