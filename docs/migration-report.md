# Отчёт о миграции

Дата: 2026-10-12.

## Перенесено

- 41 файл из текущего `scripts/*.rsc.txt`;
- ранее также `doPeriodicLogDump`, `doPeriodicLogParse`, `doTelegramNotify` из последнего
  полноразмерного tree старого Git (`3f5b2a1…`) — **позже упразднены** (см. `docs/style-canon.md` §5.5);
- архитектурная и эксплуатационная документация;
- локальные копии Rosetta, RouterOS skills и усиленного MikroTik MCP;
- MIT license и upstream license/provenance каждой зависимости.

В `src/scripts` сейчас 41 RouterOS-скрипт.

## Санитизация

Реальные credential literals заменены runtime-lookups или fail-closed runtime
variables в семи файлах. Полный перечень логических ключей и findings находится
в `docs/script-audit.md`. Значения старых секретов в новый репозиторий не
переносились.

До публикации оператор должен ротировать credentials, которые ранее находились
в старой Git-истории: cloud backup password, certificate passphrases,
bandwidth-test credentials, InfluxDB credentials/tokens и Telegram bot
credentials.

## Не перенесено

- старая Git-история и `rawconf_*`;
- binary backups, private keys/certificates и sensitive text exports;
- LivingRoomWAP;
- mobileconfig-профили;
- InfluxDB host-side utilities;
- retired `GitAutoCommit.sh`.

## Отложенные решения

- формат tracked `src/config`;
- долговременное закрытое хранилище для `bin`;
- публикация remote `Defm/mikroconf` (в т.ч. ветка `_autobranch` для gitwatch)
  и rollout на устройствах (пути в скриптах уже `mikroconf` / `src/scripts`;
  canary ещё не выполнен);
- write/apply broker.

Текущий backup и script release pipeline не выключен и не изменён.
