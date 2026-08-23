CC := cc
BASE_CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -Wshadow
VERSION ?= dev_build_$(shell date -u +%Y-%m-%d-%H-%M-%S)
CFLAGS := $(BASE_CFLAGS) -DHELLO_VERSION=\"$(VERSION)\"

TARGET := hello

.PHONY: all debug test clean

all: $(TARGET)

$(TARGET): hello.c
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

debug:
	$(MAKE) clean
	$(MAKE) CFLAGS='$(BASE_CFLAGS) -g -DHELLO_VERSION=\"$(VERSION)\"' all

test:
	@$(MAKE) clean all VERSION="$(VERSION)"
	@version_output="$$(./$(TARGET) --version)"; printf '%s\n' "$$version_output"; test "$$version_output" = 'hello $(VERSION)'
	@test "$$(./$(TARGET) -v)" = 'hello $(VERSION)'
	@test "$$(./$(TARGET) --help)" = 'Usage: ./$(TARGET) [--help|--version]'
	@test "$$(./$(TARGET) -h)" = 'Usage: ./$(TARGET) [--help|--version]'
	@output="$$(printf 'Alice\n' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Hello, Alice!'
	@output="$$(printf 'Привет\n' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Hello, Привет!'
	@output="$$(printf '  Alice Smith \t\n' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Hello, Alice Smith!'
	@output="$$(printf '\360\237\230\200\n' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Hello, 😀!'
	@output="$$(printf 'Alice' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Hello, Alice!'
	@name_99=; i=0; while [ $$i -lt 99 ]; do name_99=$${name_99}A; i=$$((i + 1)); done; \
		output="$$(printf '%s' "$$name_99" | ./$(TARGET))"; test "$$output" = "Hello, $$name_99!"
	@tmp_file="$$(mktemp)"; if printf '\n' | ./$(TARGET) >"$$tmp_file" 2>&1; then cat "$$tmp_file"; rm -f "$$tmp_file"; exit 1; else status=$$?; cat "$$tmp_file"; rm -f "$$tmp_file"; test $$status -eq 1; fi
	@tmp_file="$$(mktemp)"; if printf '\303\050\n' | ./$(TARGET) >"$$tmp_file" 2>&1; then cat "$$tmp_file"; rm -f "$$tmp_file"; exit 1; else status=$$?; cat "$$tmp_file"; rm -f "$$tmp_file"; test $$status -eq 1; fi
	@long_name=; i=0; while [ $$i -lt 100 ]; do long_name=$${long_name}A; i=$$((i + 1)); done; \
		tmp_file="$$(mktemp)"; if printf '%s\n' "$$long_name" | ./$(TARGET) >"$$tmp_file" 2>&1; then cat "$$tmp_file"; rm -f "$$tmp_file"; exit 1; else status=$$?; cat "$$tmp_file"; rm -f "$$tmp_file"; test $$status -eq 1; fi
	@tmp_file="$$(mktemp)"; if ./$(TARGET) unexpected >"$$tmp_file" 2>&1; then cat "$$tmp_file"; rm -f "$$tmp_file"; exit 1; else status=$$?; cat "$$tmp_file"; rm -f "$$tmp_file"; test $$status -eq 2; fi
	@echo "All tests passed."

clean:
	rm -f $(TARGET)
