# Архитектура

## Назначение

Репозиторий разделяет канонические исходники, чувствительные эксплуатационные артефакты и долговременное хранение. Git хранит только проверяемый код и документацию; устройства и backup storage остаются отдельными доверенными зонами.

## Компоненты

1. RouterOS на шести активных устройствах выполняет скрипты и создаёт backup/raw artifacts.
2. `doBackup` создаёт бинарный backup и raw export, передаёт их во внешнее хранилище и удаляет временные файлы.
3. На хосте `/REPO/raw` — рабочий clone `Defm/mikroconf` на ветке `_autobranch`.
   Контейнер gitwatch смотрит этот каталог и пушит автокоммиты в `_autobranch`
   (как легаси `mikrobackups`). `master` для автокоммитов не используется.
4. `doDumpTheScripts` выгружает исходники через RAM-диск в
   `REPO/raw/src/scripts/` (внутрь того же clone). Dump не очищает секреты —
   это operational loop, не sanitizer.
5. `src/scripts` — канонический каталог в Git и цель fetch/dump.
6. `doFreshTheScripts` загружает скрипты из
   `Defm/mikroconf` / `master/src/scripts` (через relay).
7. `doBackup` шлёт `.backup` и show-sensitive `.unsafe.rsc` в `REPO/raw/bin/`,
   а `/export` без show-sensitive — в `REPO/raw/src/config/<device>.safe.rsc`.

## Потоки доверия

- Git → устройство: release из `mikroconf` / `master`, ручной canary и
  поэтапное расширение.
- Устройство → `REPO/raw/src/scripts` → gitwatch → `_autobranch`: operational
  feedback; review и осознанный merge в `master` остаются обязательными перед
  изменением release-поведения.
- Устройство → `REPO/raw/bin` (restore) и `REPO/raw/src/config` (latest без
  секретов в имени show-sensitive); чувствительное в tracked Git не попадает.
- Локальный агент → внешняя система: запрещено по умолчанию.

## Инварианты

- Binary backup и полные rawconf не попадают в tracked Git.
- В Git нет секретов, `.backup` и полных exports как отдельных артефактов.
- Ошибка проверки блокирует выпуск.
