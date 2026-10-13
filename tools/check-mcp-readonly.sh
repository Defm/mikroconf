#!/usr/bin/env bash
# Local readiness check for mikrotik-readonly MCP. Does not connect to devices
# and does not print inventory hosts, usernames, or key material.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0
fail() {
  printf 'ОШИБКА: %s\n' "$*" >&2
  errors=$((errors + 1))
}

hardened="${ROOT}/vendor/mikrotik-mcp/.venv/bin/mcp-server-mikrotik-hardened"
inventory="${HOME}/.config/mikrobackups/inventory.yml"
known_hosts="${HOME}/.ssh/mikrobackups/known_hosts"

[[ -x "$hardened" ]] || fail "нет исполняемого hardened-entrypoint: vendor/mikrotik-mcp/.venv/bin/mcp-server-mikrotik-hardened (запустите: cd vendor/mikrotik-mcp && uv sync)"
[[ -f "$inventory" ]] || fail "нет inventory: ~/.config/mikrobackups/inventory.yml"
[[ -f "$known_hosts" ]] || fail "нет known_hosts: ~/.ssh/mikrobackups/known_hosts"

if [[ -f "$inventory" && -x "${ROOT}/vendor/mikrotik-mcp/.venv/bin/python" ]]; then
  "${ROOT}/vendor/mikrotik-mcp/.venv/bin/python" - "$inventory" "$known_hosts" <<'PY' || errors=$((errors + 1))
import os
import sys
from pathlib import Path

import yaml

inventory_path = Path(sys.argv[1])
known_hosts_path = Path(sys.argv[2])
raw = yaml.safe_load(inventory_path.read_text())
if not isinstance(raw, list) or not raw:
    print("ОШИБКА: inventory должен быть непустым списком устройств", file=sys.stderr)
    sys.exit(1)

required = ("title", "host", "port", "username")
placeholders = 0
missing_keys = 0
for index, item in enumerate(raw, start=1):
    if not isinstance(item, dict):
        print(f"ОШИБКА: устройство #{index} не является mapping", file=sys.stderr)
        sys.exit(1)
    missing = [name for name in required if not item.get(name)]
    if missing:
        print(f"ОШИБКА: у устройства #{index} нет полей: {', '.join(missing)}", file=sys.stderr)
        sys.exit(1)
    host = str(item.get("host") or "")
    if host.endswith(".example.invalid") or host in {"", "127.0.0.1"}:
        placeholders += 1
    key_filename = item.get("key_filename")
    if key_filename:
        if not Path(os.path.expanduser(str(key_filename))).is_file():
            missing_keys += 1
    else:
        missing_keys += 1

print(f"inventory: {len(raw)} устройств")
if placeholders:
    print(f"ОШИБКА: {placeholders} устройств всё ещё с placeholder-host из example", file=sys.stderr)
    sys.exit(1)
if missing_keys:
    print(f"ОШИБКА: нет SSH key file у {missing_keys} устройств", file=sys.stderr)
    sys.exit(1)
if not known_hosts_path.is_file() or known_hosts_path.stat().st_size == 0:
    print("ОШИБКА: known_hosts пуст — SSH RejectPolicy отклонит все устройства", file=sys.stderr)
    print("Закрепите fingerprint через ./tools/pin-host-key.sh <host> SHA256:...", file=sys.stderr)
    sys.exit(1)
print(f"known_hosts: {known_hosts_path.stat().st_size} байт")
PY
fi

if ((errors)); then
  printf 'Проверка mikrotik-readonly не прошла: %d\n' "$errors" >&2
  exit 1
fi

printf 'OK: локальный контур mikrotik-readonly готов (без проверки SSH).\n'
