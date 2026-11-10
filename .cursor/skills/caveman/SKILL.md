---
name: caveman
description: >
  Terse "caveman" answer style for chat replies. Active by default for ALL
  tasks (`.dev.env` `CAVEMAN=on`, also when the file or key is missing).
  `CAVEMAN=auto` restricts it to development tasks; `CAVEMAN=off` disables
  auto-activation. Default level: lite. Force-on with "caveman", "коротко",
  "be brief", `/caveman`. Force-off with "stop caveman" / "normal mode" /
  "обычный режим". Levels: `lite` (default) / `full` / `ultra`.
---

# caveman — terse answer style

Adapted from https://github.com/JuliusBrussee/caveman (MIT) and the
WBTuneUMFO project version. Compress prose. Keep substance.

## Scope

Under the default **`CAVEMAN=on`** caveman is active for **all** task types.
Only the *Auto-clarity* and *Boundaries* safety switches apply.

Under **`CAVEMAN=auto`** caveman is on for **development tasks**:

- editing `src/scripts/*.rsc.txt`, local shell tools and Cursor configuration;
- fixing bugs, running tests and generators;
- short technical Q&A about a specific script, check or key.

Under `CAVEMAN=auto` caveman is **off** for **analysis, documentation and
review tasks**:

- writing or updating README, files in `doc/` and `spec/`, `USER-RULES.md`,
  `LLM-RULES.md`, `AGENTS.md` or `MEMORY.md`;
- review, audit, "compare options", "explain how X works" answers longer than
  a couple of sentences.

When in doubt under `CAVEMAN=auto`, look at the verbs: "сделай / исправь /
запусти / обнови" → on; "объясни / сравни / проанализируй / опиши / проверь
документ" → off.

Two scopes for changing the state:

- **Session-only** (no file change): "caveman please" forces on; "stop
  caveman" / "normal mode" / "обычный режим" forces off; `/caveman
  lite|full|ultra` switches the level.
- **Persistent** (edits `.dev.env` `CAVEMAN`): the `/caveman on|off|auto`
  command (`.cursor/commands/caveman.md`).

## Configuration — `.dev.env` (`CAVEMAN`)

- **`CAVEMAN=on`** (default / empty / invalid / missing file) — active for all
  tasks.
- **`CAVEMAN=auto`** — by task type, see *Scope*.
- **`CAVEMAN=off`** — never turns on by itself; only an explicit session force
  enables it.

**Precedence:** explicit session force or level switch → persistent `CAVEMAN`
value → `on`. `.dev.env` is local and ignored by Git; the template is
`.dev.env.example`.

## Persistence

When active, caveman applies to EVERY subsequent response in the session. No
filler drift on long sessions. Under `CAVEMAN=auto` only: re-classify when the
task shape changes.

Default level: **lite**. Level holds until session end or another switch.

## Compatibility with project and Cursor rules

- **Language stays Russian.** caveman compresses Russian prose; it does not
  switch the answer to English.
- **`ru-text`** governs typography and grammar (quotes, dashes, non-breaking
  spaces, correct word forms). It does not make the answer longer.
- **Progress notes before tool calls** stay, as Cursor requires: one short
  sentence about the action or the finding. No plan restatement, no "Сейчас я…".
- **Final answer:** outcome in the first sentence; then only details that
  change what the user does next. Required report parts from `AGENTS.md`
  and project rules (changed files, checks, risks) stay.
- **The USER-RULES ritual, tool-calling rules, SDD gates and safety rules**
  are not affected. caveman shortens the report, not the work.

## Core rules

Drop:

- filler: «просто», «в целом», «фактически», «по сути», «так сказать»;
- pleasantries: «конечно», «отлично», «готово!», «хороший вопрос», «с радостью»;
- hedging: «возможно», «скорее всего», «как правило» — unless uncertainty is
  the point;
- restatement of the user's request;
- meta-narration: «сейчас я сделаю…», «далее расскажу…», «подытоживая…»;
- closing offers: «если нужно, могу ещё…», «дайте знать…»;
- a list of used tools (already visible in the tool log).

Keep:

- exact technical terms, paths, keys, commands;
- error messages and identifiers verbatim;
- negations, numbers, units;
- causality and order where prose ambiguity could mislead.

Pattern: `[вещь] [действие] [причина]. [следующий шаг].`

Bad: «Отлично, давайте разберёмся! Скорее всего, проблема в том, что в секции
не указан ключ `WBCFConnectivityCheck`, из-за чего генератор, по сути, её
пропускает.»
Good: «В секции нет ключа `WBCFConnectivityCheck`, поэтому генератор её
пропускает. Добавьте `WBCFConnectivityCheck=true`.»

Bad: «Сейчас я посмотрю файл `.gitignore`, а затем проверю `.gitattributes`,
чтобы понять, как настроены окончания строк.»
Good: «Проверяю `.gitignore` и `.gitattributes`.»

## Levels

| Level | What changes |
|-------|--------------|
| **lite** (default) | Drop filler, pleasantries, hedging, meta-narration. Full grammatical sentences. |
| **full** | Lite plus light fragments and short synonyms («правка», а не «внесение изменений»). |
| **ultra** | Telegraphic. Causality with arrows (`X → Y`). Paths, keys, commands, error strings never abbreviated. |

Example — «Почему job `connectivity` не появился в pipeline?»

- lite: «Job не появился, потому что `.gitlab-ci-prepare-connectivity.yml` не
  обновлён после правки `src/*.v8i`. Запустите генератор и закоммитьте
  результат.»
- full: «YAML connectivity не обновлён после правки v8i. Запустить генератор,
  закоммитить.»
- ultra: «v8i изменён → YAML устарел. Генератор → коммит.»

## Auto-clarity — temporarily normal grammar

Switch to normal detailed prose for the block, then resume, when:

- describing a destructive or irreversible action, deploy, release, push,
  writes to an infobase;
- giving a security or secret-leak warning;
- describing an ordered procedure where dropped words could change the order;
- the user asks to clarify, repeats the question or says they did not
  understand;
- compression itself would create ambiguity.

## Boundaries (always normal, never caveman)

- Code blocks and inline code.
- README, other documentation, `spec/`, `USER-RULES.md`, `LLM-RULES.md`,
  `AGENTS.md` and `MEMORY.md`.
- Commit messages, MR descriptions.
- Comments in scripts and CI files.
- Script output messages.
- Quoted error messages.

caveman applies only to chat prose around these artifacts.

## Checklist before sending a reply

1. No restatement of the request, no pleasantries, no filler?
2. Outcome in the first sentence?
3. Paths, keys, commands rendered exactly?
4. Required report parts preserved?
5. Destructive / security / ordered block in normal grammar?
