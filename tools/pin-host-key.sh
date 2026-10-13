#!/usr/bin/env bash
# Pin one SSH host key into the dedicated MikroTik known_hosts file.
# Does not copy from ~/.ssh/known_hosts. Writes only when the scanned key
# matches an operator-supplied SHA256 fingerprint.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  pin-host-key.sh <host> SHA256:<fingerprint> [known_hosts_path]

Default known_hosts:
  ~/.ssh/mikrobackups/known_hosts

Obtain the fingerprint out of band (WinBox, device label, previously verified
key). Do not pin ssh-keyscan output unless it matches that fingerprint.
EOF
}

[[ $# -eq 2 || $# -eq 3 ]] || { usage >&2; exit 2; }

host=$1
expected=$2
known_hosts=${3:-"${HOME}/.ssh/mikrobackups/known_hosts"}

[[ "$expected" =~ ^SHA256:[A-Za-z0-9+/]+=*$ ]] || {
  printf 'Refusing: fingerprint must look like SHA256:...\n' >&2
  exit 2
}
[[ -n "$host" && "$host" != *[[:space:]]* ]] || {
  printf 'Refusing: host must be a single token\n' >&2
  exit 2
}
[[ -f "$known_hosts" ]] || {
  printf 'Refusing: known_hosts does not exist: %s\n' "$known_hosts" >&2
  exit 2
}

if ssh-keygen -F "$host" -f "$known_hosts" >/dev/null 2>&1; then
  printf 'Already pinned: %s in %s\n' "$host" "$known_hosts"
  exit 0
fi

scan=$(ssh-keyscan -T 5 -t ed25519,ecdsa,rsa "$host" 2>/dev/null || true)
[[ -n "$scan" ]] || {
  printf 'Refusing: ssh-keyscan returned no keys for %s\n' "$host" >&2
  exit 1
}

matched=""
while IFS= read -r line; do
  [[ -n "$line" && "$line" != \#* ]] || continue
  fp=$(printf '%s\n' "$line" | ssh-keygen -lf - -E sha256 | awk '{print $2}')
  if [[ "$fp" == "$expected" ]]; then
    matched=$line
    break
  fi
done <<<"$scan"

[[ -n "$matched" ]] || {
  printf 'Refusing: scanned keys for %s do not match the supplied fingerprint\n' "$host" >&2
  exit 1
}

printf '%s\n' "$matched" >>"$known_hosts"
chmod 600 "$known_hosts"
printf 'Pinned %s with matching SHA256 fingerprint.\n' "$host"
