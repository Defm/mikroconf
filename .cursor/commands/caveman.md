---
description: "Toggle the caveman answer style: on|off|auto persist CAVEMAN in .dev.env, lite|full|ultra switch the session level, status reports the state"
argumentHint: "[on|off|auto|status|lite|full|ultra]"
---

# /caveman — answer style toggle

Canonical behaviour of the style — the `caveman` skill
(`.cursor/skills/caveman/SKILL.md`). Read the skill before acting.

Two scopes, do not mix them:

- **Persistent (edits `.dev.env`):** `on` / `off` / `auto` write the `CAVEMAN`
  key and take effect in every chat, including new ones.
- **Session-only (no file change):** `lite` / `full` / `ultra` switch the level
  for this chat; "caveman please" forces on, "stop caveman" / "normal mode" /
  "обычный режим" forces off. A session force overrides `.dev.env`.

Parse the argument: empty or `on` → `on`; `off` → `off`; `auto` → `auto`;
`status` → report without editing; `lite` / `full` / `ultra` → session level
only.

## on / off / auto

1. If `.dev.env` is missing, copy `.dev.env.example` to `.dev.env`.
2. Set `CAVEMAN=<value>`: replace the existing line or append it at the end.
   Do not touch other keys or other files.
3. Apply the new mode immediately in this session.
4. Confirm in 2–3 lines, in Russian: what is written to `.dev.env`, what it
   means, how to switch back.

## lite / full / ultra

Switch the session level only, without writing `.dev.env`. Confirm in one line.

## status

Read only the `CAVEMAN` key from `.dev.env` without editing. Do not read
or report other keys or values. Report:

- `CAVEMAN` value (missing file / key / empty / invalid = `on`) and its meaning;
- the session state if a force or level switch was issued in this chat.

## Constraints

The toggle changes only presentation. It never affects SDD gates, safety rules,
tool-calling rules, verification or required report parts.
