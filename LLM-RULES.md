# LLM Rules

Agent-maintained behavior rules for this project. Write this file only through
the `/evolve` command with per-entry user approval.

Last /evolve run: 2026-11-10

## Active rules

| ID | Trigger | USER-RULES anchor |
|----|---------|-------------------|
| R-001 | Pre-send ritual | Ритуал ответов по ограничениям USER-RULES.md |

### R-001 — Apply the USER-RULES ritual before acting (2026-11-10)

- **Rule:** After the bootstrap reads `USER-RULES.md`, perform a pre-send gate
  before every user-visible reply and before every tool call other than reading
  the rules themselves. Identify all applicable operational requirements and
  restrictions. A relevant `ask` section triggers the ritual even when the
  current request already contains consent; an active `never` section always
  triggers it; an `always` section triggers it when it changes the requested
  order, method, composition, scope, or number of actions, requires refusal,
  waiting, a mandatory preparatory step, or an alternate procedure, or bans a
  tool or step. When triggered, start the first visible reply with the exact
  prefix required by `USER-RULES.md`, list every triggering section and label
  once, then comply immediately. Do not put progress narration, reasoning, or
  unrelated tool calls before the prefix. Language, terminology, style,
  formatting, and routine quality requirements do not trigger the ritual by
  themselves.
- **Scope:** Every user request and every user-visible reply in this project.
- **Evidence:** On 2026-11-10 the user approved the complete USER-RULES
  harness for `mikroconf`, including the section-by-section wording review,
  exact ritual semantics, and this pre-send gate.
- **Refines:** `USER-RULES.md → Ритуал ответов по ограничениям USER-RULES.md`;
  `.cursor/rules/user-rules-bootstrap.mdc`; `AGENTS.md → Agent harness`.

## Superseded
