#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define NAME_BUFFER_SIZE 100
#ifndef HELLO_VERSION
#define HELLO_VERSION "dev"
#endif

static int utf8_sequence_length(const unsigned char *text, size_t remaining)
{
    unsigned char first = text[0];

    if (first < 0x80) {
        return 1;
    }
    if (first >= 0xc2 && first <= 0xdf) {
        return remaining >= 2 && text[1] >= 0x80 && text[1] <= 0xbf ? 2 : 0;
    }
    if (first >= 0xe0 && first <= 0xef) {
        if (remaining < 3) {
            return 0;
        }
        if (first == 0xe0 && (text[1] < 0xa0 || text[1] > 0xbf)) {
            return 0;
        }
        if (first == 0xed && (text[1] < 0x80 || text[1] > 0x9f)) {
            return 0;
        }
        return text[1] >= 0x80 && text[1] <= 0xbf &&
                       text[2] >= 0x80 && text[2] <= 0xbf
                   ? 3
                   : 0;
    }
    if (first >= 0xf0 && first <= 0xf4) {
        if (remaining < 4) {
            return 0;
        }
        if (first == 0xf0 && (text[1] < 0x90 || text[1] > 0xbf)) {
            return 0;
        }
        if (first == 0xf4 && (text[1] < 0x80 || text[1] > 0x8f)) {
            return 0;
        }
        return text[1] >= 0x80 && text[1] <= 0xbf &&
                       text[2] >= 0x80 && text[2] <= 0xbf &&
                       text[3] >= 0x80 && text[3] <= 0xbf
                   ? 4
                   : 0;
    }

    return 0;
}

static int valid_utf8(const char *text)
{
    const unsigned char *current = (const unsigned char *)text;
    size_t remaining = strlen(text);

    while (remaining > 0) {
        int length = utf8_sequence_length(current, remaining);

        if (length == 0) {
            return 0;
        }
        current += length;
        remaining -= (size_t)length;
    }

    return 1;
}

static int read_name(char *name, int capacity)
{
    int next_char;
    char *start;
    char *end;

    fputs("Enter your name: ", stdout);
    fflush(stdout);

    if (fgets(name, capacity, stdin) == NULL) {
        if (ferror(stdin)) {
            perror("Failed to read your name");
        } else {
            fputs("No name was entered.\n", stderr);
        }
        return 1;
    }

    if (strchr(name, '\n') == NULL) {
        next_char = getchar();
        if (next_char != '\n' && next_char != EOF) {
            do {
                next_char = getchar();
            } while (next_char != '\n' && next_char != EOF);

            if (ferror(stdin)) {
                perror("Failed to read your name");
            } else {
                fprintf(stderr,
                    "The name is too long (maximum %d characters).\n",
                        capacity - 1);
            }
            return 1;
        }
    } else {
        name[strcspn(name, "\n")] = '\0';
    }

    if (!valid_utf8(name)) {
        fputs("The name must contain valid UTF-8 text.\n", stderr);
        return 1;
    }

    start = name;
    while (isspace((unsigned char)*start)) {
        start++;
    }

    end = name + strlen(name);
    while (end > start && isspace((unsigned char)end[-1])) {
        end--;
    }
    *end = '\0';

    if (start != name) {
        memmove(name, start, (size_t)(end - start) + 1);
    }

    if (name[0] == '\0') {
        fputs("The name cannot be empty.\n", stderr);
        return 1;
    }

    return 0;
}

int main(int argc, char *argv[])
{
    char name[NAME_BUFFER_SIZE];

    if (argc == 2 && strcmp(argv[1], "--version") == 0) {
        printf("hello %s\n", HELLO_VERSION);
        return 0;
    }
    if (argc != 1) {
        fprintf(stderr, "Usage: %s [--version]\n", argv[0]);
        return 2;
    }

    if (read_name(name, (int)sizeof(name)) != 0) {
        return 1;
    }

    printf("Hello, %s!\n", name);
    return 0;
}
