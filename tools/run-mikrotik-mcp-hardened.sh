#!/usr/bin/env bash
# Cursor ignores vendor/mikrotik-mcp/.venv/ (.cursorignore) and reports ENOENT
# if mcp.json points at the console script inside the venv. Launch via this
# wrapper, which lives outside the ignore and execs the real entrypoint.
set -euo pipefail
ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
PY="$ROOT/vendor/mikrotik-mcp/.venv/bin/python"
if [[ ! -x "$PY" ]]; then
  echo "mikrotik-mcp venv python missing: $PY" >&2
  echo "Create it under vendor/mikrotik-mcp (uv sync / pip install -e .) before starting MCP." >&2
  exit 127
fi
exec "$PY" -c 'from mcp_mikrotik.server import hardened_main; hardened_main()' "$@"
