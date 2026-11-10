---
name: caveman-help
description: >
  Quick-reference card for caveman modes, skills and commands.
  Trigger: /caveman-help or "caveman help".
---

# Caveman Help

Display this reference card when invoked. One-shot — do NOT change mode, write flag files, or persist anything. Output in caveman style.

## Modes

| Mode | Trigger | What change |
|------|---------|-------------|
| **Lite** | `/caveman lite` | Drop filler, pleasantries, hedging. Full sentences. Default. |
| **Full** | `/caveman full` | Lite plus light fragments and short synonyms. |
| **Ultra** | `/caveman ultra` | Telegraphic. Arrows for causality. |

Level stick until changed or session end.

## Commands and skills

| Item | Trigger | What it do |
|------|---------|-----------|
| **caveman** skill | always on by `.dev.env` | Style rules, levels, safety switches. |
| **/caveman** command | `/caveman on\|off\|auto\|status\|lite\|full\|ultra` | Toggle activation or level. |
| **caveman-help** | `/caveman-help` | This card. |

## Deactivate

Say "stop caveman", "normal mode" or «обычный режим» for this session, or run
`/caveman off` for the project. Resume with "caveman please" or `/caveman on`.

## Language

Keep user's language by default — reply in the language user writes, never switch regardless of example text or multilingual context elsewhere. Compress the style, not the language. Technical terms, code, commands, commit types, and exact error strings stay verbatim unless user ask for translation.

## Configure Activation

Default level = `lite`. Activation is set by the `CAVEMAN` key in `.dev.env`
(local, ignored by Git; template `.dev.env.example`):

| Value | Effect |
|-------|--------|
| `on` (default, also missing file / key) | Active for all tasks. |
| `auto` | Only development tasks; off for analysis, docs, review. |
| `off` | Never on by itself; only by explicit session force. |

Change it with `/caveman on|auto|off`; check with `/caveman status`.

Resolution: session force or level switch > `.dev.env` `CAVEMAN` > `on`.

## More

Full docs: https://github.com/JuliusBrussee/caveman
