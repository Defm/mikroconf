#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUN=/opt/homebrew/bin/bun
DB_PATH="$ROOT/.cache/rosetta/ros-help.db"

usage() {
  printf 'Использование: %s doctor|sync\n' "${0##*/}" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
case "$1" in
  doctor) script=db-doctor.ts ;;
  sync) script=db-sync.ts ;;
  *) usage ;;
esac

if [[ ! -x "$BUN" ]]; then
  printf 'ОШИБКА: Bun не найден: %s\n' "$BUN" >&2
  exit 127
fi

mkdir -p "$(dirname "$DB_PATH")"
export DB_PATH
exec "$BUN" run "$ROOT/vendor/rosetta/scripts/$script"
