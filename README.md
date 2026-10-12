# mikrobackups

Безопасный репозиторий исходников RouterOS-скриптов, эксплуатационной документации и локальных защитных проверок для домашней инфраструктуры MikroTik.

## Статус

Репозиторий находится на этапе безопасной миграции. Активные устройства: `anna`, `capxl`, `capax`, `atl`, `CHR`, `mikrouter`. Канонический каталог скриптов — [`src/scripts`](src/scripts). До отдельного переключения устройства продолжают загружать скрипты из исторического пути `master/scripts`; целевой путь после cutover — `master/src/scripts`.

Текущий raw-конвейер и долговременное хранилище резервных копий не отключаются, пока не подтверждены полнота, срок хранения и восстановление из новой схемы.

## Структура

- `src/scripts/` — 44 RouterOS-скрипта, предназначенные для публикации;
- `src/config/` — будущая tracked-конфигурация; формат выбирается после raw-аудита;
- `src/safe/` — полные чувствительные text restore-exports; содержимое не коммитится;
- `bin/` — локальные бинарные backup-файлы; содержимое не коммитится;
- `docs/` — архитектура, инвентарь, безопасность и runbooks;
- `vendor/` — локальные копии исходников Rosetta, RouterOS skills и усиленного MikroTik MCP с upstream-лицензиями и provenance;
- `tools/check-repository.sh` — локальная проверка репозитория.

## Быстрый старт

```sh
./tools/check-repository.sh
```

Перед изменением скриптов прочитайте [`AGENTS.md`](AGENTS.md), [`CONTRIBUTING.md`](CONTRIBUTING.md) и [порядок выпуска](docs/operations/script-release.md). Не подключайтесь к устройствам и не выполняйте удалённые команды из этого репозитория без отдельного явного разрешения оператора.

## Основные документы

- [Архитектура](docs/architecture.md)
- [Инвентарь устройств](docs/devices/inventory.md)
- [Конвейер резервного копирования](docs/operations/backup-pipeline.md)
- [Политика raw-экспортов](docs/operations/raw-policy.md)
- [Учётные данные](docs/security/credentials.md)
- [Проектирование путей записи](docs/security/write-path-design.md)
- [Аудит RouterOS-скриптов](docs/script-audit.md)
- [Обзор RouterOS skills](docs/routeros-skills-review.md)
- [Отчёт о миграции](docs/migration-report.md)
- [План будущего cutover](docs/cutover-plan.md)

Лицензия: [MIT](LICENSE).
