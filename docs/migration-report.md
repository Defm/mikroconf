# Отчёт о миграции

Дата: 2026-10-12.

## Перенесено

- 41 файл из текущего `scripts/*.rsc.txt`;
- `doPeriodicLogDump`, `doPeriodicLogParse`, `doTelegramNotify` из последнего
  полноразмерного tree старого Git (`3f5b2a1…`);
- архитектурная и эксплуатационная документация;
- локальные копии Rosetta, RouterOS skills и усиленного MikroTik MCP;
- MIT license и upstream license/provenance каждой зависимости.

Все 44 RouterOS-скрипта находятся в `src/scripts`. Имена сохранены.

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
- долговременное закрытое хранилище для `src/safe` и `bin`;
- GitHub URL;
- production cutover на `master/src/scripts`;
- write/apply broker.

Текущий backup и script release pipeline не выключен и не изменён.
