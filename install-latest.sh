#!/usr/bin/env bash
set -euo pipefail

repository="ufsoftme-creator/hello-c"
install_dir="${PREFIX:-$HOME/.local}/bin"
temporary_dir="$(mktemp -d)"
trap 'rm -rf -- "$temporary_dir"' EXIT

case "$(uname -m)" in
    x86_64|amd64) architecture="x86_64" ;;
    aarch64|arm64) architecture="arm64" ;;
    *) printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2; exit 1 ;;
esac

asset="hello-${architecture}.tar.gz"
base_url="https://github.com/${repository}/releases/latest/download"

curl -fsSL "${base_url}/${asset}" -o "${temporary_dir}/${asset}"
curl -fsSL "${base_url}/SHA256SUMS.txt" -o "${temporary_dir}/SHA256SUMS.txt"
grep -F "  ${asset}" "${temporary_dir}/SHA256SUMS.txt" > "${temporary_dir}/asset.sha256"
(cd "$temporary_dir" && sha256sum -c asset.sha256)

mkdir -p "$install_dir"
tar -xzf "${temporary_dir}/${asset}" -C "$temporary_dir"
install -m 0755 "${temporary_dir}/hello" "${install_dir}/hello"

printf 'Installed hello to %s/hello\n' "$install_dir"