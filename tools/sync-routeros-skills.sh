#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/vendor/routeros-skills"
TARGET="$ROOT/.cursor/skills"

usage() {
  printf 'Использование: %s apply|check\n' "${0##*/}" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
mode=$1
case "$mode" in
  apply|check) ;;
  *) usage ;;
esac

build() {
  local destination=$1
  mkdir -p "$destination"
  cp "$SOURCE/LICENSE" "$destination/LICENSE.routeros-skills"
  cp "$SOURCE/UPSTREAM_COMMIT" "$destination/UPSTREAM_COMMIT"

  local source_dir name
  for source_dir in "$SOURCE"/routeros-*/; do
    name=${source_dir%/}
    name=${name##*/}
    cp -R "$source_dir" "$destination/$name"
  done

  python3 - "$destination" <<'PY'
import sys
from pathlib import Path

root = Path(sys.argv[1])
automatic = {
    "routeros-fundamentals",
    "routeros-scripting",
    "routeros-syntax-inspection",
    "routeros-centrs",
}

for skill_file in sorted(root.glob("routeros-*/SKILL.md")):
    text = skill_file.read_text()
    name = skill_file.parent.name
    if name not in automatic:
        marker = "\n---\n"
        frontmatter, body = text[4:].split(marker, 1)
        if "disable-model-invocation:" not in frontmatter:
            frontmatter += "\ndisable-model-invocation: true"
        text = f"---\n{frontmatter}{marker}{body}"

    if name == "routeros-centrs":
        sentence = (
            " Live execute/SSH still requires explicit operator permission "
            "in this repository."
        )
        lines = text.splitlines(keepends=True)
        for index, line in enumerate(lines):
            if line.startswith("description: ") and sentence.strip() not in line:
                newline = "\n" if line.endswith("\n") else ""
                value = line.removesuffix("\n")
                if not value.endswith('"'):
                    raise SystemExit("unexpected routeros-centrs description format")
                lines[index] = value[:-1] + sentence + '"' + newline
                break
        else:
            raise SystemExit("routeros-centrs description not found")
        text = "".join(lines)

    skill_file.write_text(text)
PY
}

temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT
generated="$temporary/skills"
build "$generated"

if [[ "$mode" == check ]]; then
  current="$temporary/current"
  mkdir -p "$current"
  cp "$TARGET/LICENSE.routeros-skills" "$current/LICENSE.routeros-skills"
  cp "$TARGET/UPSTREAM_COMMIT" "$current/UPSTREAM_COMMIT"
  for source_dir in "$TARGET"/routeros-*/; do
    name=${source_dir%/}
    name=${name##*/}
    cp -R "$source_dir" "$current/$name"
  done

  if ! diff -rq "$generated" "$current"; then
    printf 'ОШИБКА: .cursor/skills расходится с vendor/routeros-skills.\n' >&2
    printf 'Запустите: ./tools/sync-routeros-skills.sh apply\n' >&2
    exit 1
  fi
  printf 'OK: .cursor/skills синхронизирован с vendor/routeros-skills.\n'
  exit 0
fi

rm -rf "$TARGET"/routeros-*
rm -f "$TARGET/LICENSE.routeros-skills" "$TARGET/UPSTREAM_COMMIT"
cp -R "$generated"/. "$TARGET"/
printf 'OK: .cursor/skills обновлён из vendor/routeros-skills.\n'
