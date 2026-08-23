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
	$(MAKE) CFLAGS="$(BASE_CFLAGS) -g" all

test:
	@$(MAKE) clean all VERSION="$(VERSION)"
	@version_output="$$(./$(TARGET) --version)"; printf '%s\n' "$$version_output"; test "$$version_output" = 'hello $(VERSION)'
	@output="$$(printf 'Alice\n' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Enter your name: Hello, Alice!'
	@output="$$(printf 'Привет\n' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Enter your name: Hello, Привет!'
	@output="$$(printf '  Alice Smith \t\n' | ./$(TARGET))"; printf '%s\n' "$$output"; test "$$output" = 'Enter your name: Hello, Alice Smith!'
	@tmp_file="$$(mktemp)"; if printf '\n' | ./$(TARGET) >"$$tmp_file" 2>&1; then cat "$$tmp_file"; rm -f "$$tmp_file"; exit 1; else status=$$?; cat "$$tmp_file"; rm -f "$$tmp_file"; test $$status -eq 1; fi
	@tmp_file="$$(mktemp)"; if printf '\303\050\n' | ./$(TARGET) >"$$tmp_file" 2>&1; then cat "$$tmp_file"; rm -f "$$tmp_file"; exit 1; else status=$$?; cat "$$tmp_file"; rm -f "$$tmp_file"; test $$status -eq 1; fi
	@long_name=; i=0; while [ $$i -lt 100 ]; do long_name=$${long_name}A; i=$$((i + 1)); done; \
		tmp_file="$$(mktemp)"; if printf '%s\n' "$$long_name" | ./$(TARGET) >"$$tmp_file" 2>&1; then cat "$$tmp_file"; rm -f "$$tmp_file"; exit 1; else status=$$?; cat "$$tmp_file"; rm -f "$$tmp_file"; test $$status -eq 1; fi
	@echo "All tests passed."

clean:
	rm -f $(TARGET)