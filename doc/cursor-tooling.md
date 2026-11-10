# Вендорные инструменты в Cursor

В `vendor/` зафиксированы исходники трёх внешних проектов. Они не являются
вложенными рабочими репозиториями: версия каждого источника записана в
`UPSTREAM_COMMIT`, а проектовая обвязка находится вне `vendor/`.

## Пользовательские соглашения

Корневой `USER-RULES.md` хранит политики пользователя, терминологию, ритуал
ответов и критичные границы. `LLM-RULES.md` содержит одобренные через
`/evolve` правила поведения агента, а `AGENTS.md` маршрутизирует к нужным
rules, skills и документам.

Правило `.cursor/rules/user-rules-bootstrap.mdc` загружает эту обвязку
в начале нового чата. Для нетривиальных изменений используется цикл SDD
из `spec/README.md` и skills `sdd-*`. Навыки `ru-text`, `caveman`
и `design-doc-mermaid` отвечают за русский текст, краткость ответов
и диаграммы.

## Назначение

### Rosetta

`vendor/rosetta` — офлайн-индекс официальной документации RouterOS v7 на
SQLite FTS5. Bun-процесс `src/mcp.ts` предоставляет Cursor MCP-инструменты
поиска, чтения страниц, просмотра дерева команд и проверки версий. Он не
подключается к устройствам.

Upstream поддерживает несколько клиентов:

- `CLAUDE.md`, `.mcp.json` и `.claude/skills` — Claude Code;
- `AGENTS.md` и команда `codex mcp add` — Codex;
- `.github/instructions`, `.github/prompts` и `.vscode/mcp.json` — Copilot.

Эти файлы описывают разработку самого rosetta. В `mikroconf` их не применяют
как инструкции проекта. Для Cursor сервер зарегистрирован в
`.cursor/mcp.json`, а правила изоляции находятся в
`.cursor/rules/vendor.mdc`.

### RouterOS skills

`vendor/routeros-skills` содержит 17 справочных skills и их `references/`.
Upstream-команда `make link` создаёт пользовательские симлинки для Claude,
Codex, Copilot и Hermes. В этом репозитории её не запускают.

Cursor читает проектовые копии из `.cursor/skills`. Они воспроизводимо
формируются командой:

```sh
./tools/sync-routeros-skills.sh apply
```

Четыре skills доступны для автоматического выбора:
`routeros-fundamentals`, `routeros-scripting`,
`routeros-syntax-inspection` и `routeros-centrs`. Остальные имеют
`disable-model-invocation: true` и вызываются вручную. Регистрация skill не
разрешает удалённые или write-capable операции.

### MikroTik MCP

`vendor/mikrotik-mcp` — Python MCP-сервер для чтения состояния устройств.
Локальные усиления описаны в `vendor/mikrotik-mcp/LOCAL_CHANGES.md`:

- профиль `hardened-read-only` и явный allowlist инструментов;
- скрытие чувствительных данных;
- только stdio;
- проверенный отдельный `known_hosts` и SSH `RejectPolicy`.

Cursor запускает сервер через `tools/run-mikrotik-mcp-hardened.sh`. Даже
read-only подключение к реальному устройству требует явного разрешения
оператора.

## Соответствие механизмов

- MCP-конфигурация Claude/Copilot заменена проектовым `.cursor/mcp.json`.
- Upstream skills устанавливаются в проектовый `.cursor/skills`, а не в
  пользовательские домашние каталоги.
- `CLAUDE.md`, `AGENTS.md` и Copilot instructions внутри vendor изолированы
  правилом `.cursor/rules/vendor.mdc`.
- Copilot prompt `search-docs.prompt.md` перенесён в Cursor-команду
  `/routeros-docs`.
- Для офлайн-review `.rsc.txt` добавлена команда `/routeros-check-script`.
- Перед MCP- и shell-вызовами работают fail-closed hooks из
  `.cursor/hooks.json`.
- Пользовательские политики загружаются через `USER-RULES.md`, bootstrap
  и поведенческий gate R-001 из `LLM-RULES.md`.
- `.cursorignore` исключает тяжёлые среды из индекса Cursor, а `.gitignore`
  исключает локальные БД и Python cache из Git.

## Размещение обвязки

- `.cursor/mcp.json` — два stdio MCP-сервера;
- `.cursor/skills/` — RouterOS skills, SDD, `ru-text`, `caveman`
  и `design-doc-mermaid`;
- `.cursor/commands/` — повторяемые команды поиска, проверки и управления
  локальным поведением;
- `.cursor/rules/` — правила RouterOS, безопасности и vendor;
- `.cursor/hooks/` и `.cursor/hooks.json` — блокировка удалённых shell- и
  write-capable MCP-операций;
- `spec/` — требования и решения SDD-изменений;
- `tools/sync-routeros-skills.sh` — сборка и проверка skills;
- `tools/rosetta-db.sh` — работа с проектовой БД rosetta;
- `tools/run-mikrotik-mcp-hardened.sh` — запуск read-only MCP;
- `.cache/rosetta/ros-help.db` — локальная, некоммитимая БД.

## Первичная подготовка

Установка зависимостей и загрузка БД обращаются к сети. Выполняйте их только
после решения оператора:

```sh
brew install bun uv
cd vendor/rosetta && bun install --frozen-lockfile
cd ../mikrotik-mcp && uv sync
cd ../..
./tools/rosetta-db.sh sync
```

Затем выполните локальные проверки:

```sh
./tools/rosetta-db.sh doctor
./tools/check-mcp-readonly.sh
./tools/sync-routeros-skills.sh check
./tools/check-repository.sh
```

`check-mcp-readonly.sh` не подключается к устройствам и не печатает inventory.
После подготовки перезапустите Cursor, чтобы он перечитал MCP и skills.

## Порядок применения

1. Перед `/routeros-docs` или обращением к MCP rosetta получите явное
   разрешение пользователя на конкретный поиск.
2. Для редактирования `.rsc.txt` применяйте `routeros-fundamentals` и
   `routeros-scripting`; для review используйте `/routeros-check-script`.
3. Если документации недостаточно, отделите локальную проверку от обращения к
   устройству.
4. Перед любым live read получите разрешение и только затем используйте
   `mikrotik-readonly`.
5. Write, deploy, import, restore, reboot и изменение устройства не разрешены
   этой обвязкой и требуют отдельной операции и плана отката.

## Обновление vendor

1. Получите новый upstream в отдельной проверяемой операции.
2. Просмотрите diff, лицензию, исполняемые файлы, hooks и изменения модели
   безопасности.
3. Обновите соответствующий `UPSTREAM_COMMIT`. Локальные изменения vendored
   source зафиксируйте в `LOCAL_CHANGES.md` зависимости.
4. Для RouterOS skills выполните
   `./tools/sync-routeros-skills.sh apply`.
5. Проверьте `./tools/rosetta-db.sh doctor`, если менялись rosetta или схема
   БД.
6. Завершите обновление командой `./tools/check-repository.sh`.

Не запускайте upstream `make link`: он пишет за пределы репозитория. Не
доверяйте новым hooks, skills и исполняемым файлам до review.
