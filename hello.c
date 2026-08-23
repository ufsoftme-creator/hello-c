#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define NAME_BUFFER_SIZE 100

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

int main(void)
{
    char name[NAME_BUFFER_SIZE];

    if (read_name(name, (int)sizeof(name)) != 0) {
        return 1;
    }

    printf("Hello, %s!\n", name);
    return 0;
}
