#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define NAME_BUFFER_SIZE 100

static int read_name(char *name, int capacity)
{
    int next_char;
    int has_non_whitespace = 0;

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

    for (size_t i = 0; name[i] != '\0'; i++) {
        if (!isspace((unsigned char)name[i])) {
            has_non_whitespace = 1;
            break;
        }
    }

    if (!has_non_whitespace) {
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
