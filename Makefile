CC := cc
BASE_CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -Wshadow
CFLAGS := $(BASE_CFLAGS)

TARGET := hello

.PHONY: all debug clean

all: $(TARGET)

$(TARGET): hello.c
	$(CC) $(CFLAGS) $< -o $@

debug:
	$(MAKE) clean
	$(MAKE) CFLAGS="$(BASE_CFLAGS) -g" all

clean:
	rm -f $(TARGET)