# Исходники конфигурации

Сюда `doBackup` выгружает `<device>.safe.rsc` — `/export` **без**
`show-sensitive` (операционный снимок для review/истории в дереве clone:
`REPO/raw/src/config/`).

Полные restore-экспорты с секретами и двоичные `.backup` живут в `bin/`, не здесь.
Добавление вручную подготовленных шаблонов — только после review по
`docs/operations/raw-policy.md`. В Git по умолчанию tracked только этот README.
