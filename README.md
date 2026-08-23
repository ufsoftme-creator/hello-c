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

Print the build version:

```sh
./hello --version
```

Short form:

```sh
./hello -v
```

Print usage information:

```sh
./hello --help
```

Short form:

```sh
./hello -h
```

Enable Bash TAB-completion for the command:

```sh
source hello.bash
```

Install completion in `~/.bashrc` using the release directory path:

```sh
./install-completion.sh
```

Without an explicit `VERSION`, the build reports a UTC timestamp such as
`dev_build_2026-08-23-12-34-56`. Release builds use the Git tag version.

The program accepts valid UTF-8 names up to 99 bytes, trims ASCII whitespace at
both ends, and keeps spaces inside the name. Release archives contain a statically linked
ARM64 binary suitable for Alpine-based systems.

## Tests

Run the automated checks:

```sh
make test
```

Verify downloaded release archives:

```sh
sha256sum -c SHA256SUMS.txt
```

Remove the compiled binary:

```sh
make clean
```

Build and run an Alpine container:

```sh
docker build --build-arg VERSION=docker -t hello .
docker run --rm -i hello
```