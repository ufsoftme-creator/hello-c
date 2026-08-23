#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
completion_file="$script_dir/hello.bash"
bashrc="${HOME}/.bashrc"

if [[ ! -f "$completion_file" ]]; then
    printf 'Completion file not found: %s\n' "$completion_file" >&2
    exit 1
fi

mkdir -p "$(dirname -- "$bashrc")"
touch "$bashrc"

if grep -Fq 'hello.bash' "$bashrc"; then
    printf 'Completion is already configured in %s\n' "$bashrc"
else
    printf '\n# hello command completion\nsource "%s"\n' "$completion_file" >> "$bashrc"
    printf 'Added hello completion to %s\n' "$bashrc"
fi

printf 'Start a new Bash session or run: source %q\n' "$completion_file"
