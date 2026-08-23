CC := cc
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -Wshadow -g

TARGET := hello

.PHONY: all clean

all: $(TARGET)

$(TARGET): hello.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(TARGET)