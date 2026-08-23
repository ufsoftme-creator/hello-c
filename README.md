# Hello

Small C program that reads a name and prints a greeting.

## Requirements

- C17-compatible compiler
- `make`

## Build

Build the release version:

```sh
make
```

Build with debug information:

```sh
make debug
```

Run the program:

```sh
./hello
```

The program accepts names up to 99 bytes, trims whitespace at both ends, and
keeps spaces inside the name.

## Tests

Run the automated checks:

```sh
make test
```

Remove the compiled binary:

```sh
make clean
```