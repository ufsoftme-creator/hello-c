CC := cc
BASE_CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -Wshadow
CFLAGS := $(BASE_CFLAGS)

TARGET := hello

.PHONY: all debug test clean

all: $(TARGET)

$(TARGET): hello.c
	$(CC) $(CFLAGS) $< -o $@

debug:
	$(MAKE) clean
	$(MAKE) CFLAGS="$(BASE_CFLAGS) -g" all

test: $(TARGET)
	@test "$$(printf 'Alice\n' | ./$(TARGET))" = 'Enter your name: Hello, Alice!'
	@test "$$(printf '  Alice Smith \t\n' | ./$(TARGET))" = 'Enter your name: Hello, Alice Smith!'
	@! printf '\n' | ./$(TARGET) >/dev/null 2>&1
	@long_name=; i=0; while [ $$i -lt 100 ]; do long_name=$${long_name}A; i=$$((i + 1)); done; \
		! printf '%s\n' "$$long_name" | ./$(TARGET) >/dev/null 2>&1
	@echo "All tests passed."

clean:
	rm -f $(TARGET)