# mikroconf

Безопасный репозиторий исходников RouterOS-скриптов, эксплуатационной документации и локальных защитных проверок для домашней инфраструктуры MikroTik.

## Статус

Репозиторий находится на этапе безопасной миграции. Активные устройства: `anna`, `capxl`, `capax`, `atl`, `CHR`, `mikrouter`. Канонический каталог и цель fetch/dump — [`src/scripts`](src/scripts). Release — `Defm/mikroconf` / `master/src/scripts`; operational dump — `REPO/raw/src/scripts/` (host `/REPO/raw` = clone, Docker gitwatch → `_autobranch`). Rollout — по [`doc/cutover-plan.md`](doc/cutover-plan.md).

Текущий raw-конвейер и долговременное хранилище резервных копий не отключаются, пока не подтверждены полнота, срок хранения и восстановление из новой схемы.

## Структура

- `src/scripts/` — 44 RouterOS-скрипта, предназначенные для публикации;
- `src/config/` — `<device>.safe.rsc` без show-sensitive (операционный снимок);
- `bin/` — самодостаточные restore-артефакты (`.backup`, `.unsafe.rsc`); содержимое не коммитится;
- `doc/` — архитектура, инвентарь, безопасность и runbooks;
- `vendor/` — локальные копии исходников Rosetta, RouterOS skills и усиленного MikroTik MCP с upstream-лицензиями и provenance;
- `tools/check-repository.sh` — локальная проверка репозитория.

## Быстрый старт

Перед любой работой прочитайте [`USER-RULES.md`](USER-RULES.md)
и [`AGENTS.md`](AGENTS.md). Первый файл хранит пользовательские соглашения,
второй маршрутизирует агента к процедурам, правилам и навыкам.

```sh
./tools/check-repository.sh
```

Перед изменением скриптов прочитайте [`CONTRIBUTING.md`](CONTRIBUTING.md)
и [порядок выпуска](doc/operations/script-release.md). Не подключайтесь
к устройствам и не выполняйте удалённые команды из этого репозитория
без отдельного явного разрешения оператора.

## Основные документы

- [Архитектура](doc/architecture.md)
- [Инвентарь устройств](doc/devices/inventory.md)
- [Конвейер резервного копирования](doc/operations/backup-pipeline.md)
- [Fetch и SFTP-upload](doc/operations/fetch.md)
- [Политика raw-экспортов](doc/operations/raw-policy.md)
- [Учётные данные](doc/security/credentials.md)
- [Проектирование путей записи](doc/security/write-path-design.md)
- [Аудит RouterOS-скриптов](doc/script-audit.md)
- [Обзор RouterOS skills](doc/routeros-skills-review.md)
- [Вендорные инструменты в Cursor](doc/cursor-tooling.md)
- [Отчёт о миграции](doc/migration-report.md)
- [План будущего cutover](doc/cutover-plan.md)

Лицензия: [MIT](LICENSE).
