# Обзор локальных RouterOS skills

Источник: `vendor/routeros-skills`, upstream commit указан в
`vendor/routeros-skills/UPSTREAM_COMMIT`. Все 17 skills скачаны целиком вместе
с `references/` и зарегистрированы в `.cursor/skills`.

Регистрация делает skill доступным Cursor. Поле
`disable-model-invocation: true` оставляет только ручной вызов, однако не
является техническим запретом на выполнение команд.

## Базовые

- `routeros-fundamentals` — RouterOS v7, CLI, packages, users и сеть.
- `routeros-scripting` — язык `.rsc`, selectors, globals, scheduler и
  idempotency.

Эти два непосредственно полезны для текущего исходного кода. Их можно
регистрировать автоматически либо оставить ручными.

Автоматически также доступны:

- `routeros-syntax-inspection` — как валидировать `.rsc` через `/console/inspect`
  и `:parse`; сам probe на устройство по-прежнему требует разрешения оператора.
- `routeros-centrs` — контракт centrs (`explain` / envelope / `--yes`); live
  `execute` не разрешён этим skill сам по себе.

## Справочные и inspection

- `routeros-command-tree` — дерево команд и CLI/REST mapping.
- `routeros-app-yaml` — формат RouterOS `/app`.

## Подсистемы RouterOS

- `routeros-firewall`
- `routeros-container`
- `routeros-hotspot`
- `routeros-cmr`
- `routeros-sniffer`
- `routeros-mndp`
- `routeros-mac-telnet`

Эти skills содержат operational-команды. Firewall может закрыть management
path, container/CMR менять packages и device-mode, sniffer раскрывать трафик,
а MAC Telnet не является защищённым transport. Автоматическая регистрация не
рекомендуется.

## Lab и provisioning

- `routeros-qemu-chr`
- `routeros-quickchr`
- `routeros-quickchr-cli`
- `routeros-netinstall`

`quickchr*` и `qemu-chr` полезны для будущего стенда. `netinstall` форматирует
system drive. Эти четыре остаются только ручными; `netinstall` — лишь при
отдельной задаче.

## Варианты регистрации

1. Только `routeros-fundamentals` и `routeros-scripting`, оба автоматически.
2. Четыре автоматически (`fundamentals`, `scripting`, `syntax-inspection`,
   `centrs`), остальные 13 вручную.
3. Все 17 вручную через `disable-model-invocation: true`.
4. Ничего не копировать в `.cursor/skills`: читать локальный `vendor` и
   resources `rosetta://skills` по запросу.

## Принятое решение

Автоматический выбор агентом: `routeros-fundamentals`, `routeros-scripting`,
`routeros-syntax-inspection`, `routeros-centrs`. Остальные 13 зарегистрированы
с `disable-model-invocation: true` и запускаются только вручную. Это не
отменяет правила безопасности и не разрешает live-команды само по себе.
