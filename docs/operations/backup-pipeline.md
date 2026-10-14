# Конвейер резервного копирования

## Текущий поток

1. `doBackup` проверяет базовые preconditions и основной partition.
2. Устройство создаёт `.backup`, show-sensitive `.unsafe.rsc` и `/export` без
   show-sensitive (`<device>.safe.rsc`).
3. По SFTP внутрь clone: `.backup` и `.unsafe.rsc` → `REPO/raw/bin/`;
   latest → `REPO/raw/src/config/`.
4. `doDumpTheScripts` выгружает исходники в `REPO/raw/src/scripts/`.
5. `gitwatch` коммитит `src/scripts/` в `_autobranch`. `bin/` gitignored.
6. Временные файлы на устройстве удаляются.

## Требования безопасности

- Raw exports и `.backup` никогда не направляются в этот Git-репозиторий.
- Данные доступа берутся из локального `$globalSecret`; значения не журналируются.
- Ошибка передачи не должна считаться успешным backup.
- Восстановление проверяется на изолированной системе без доступа к production.

## Retention и миграция

Существующий raw pipeline остаётся включённым, пока новая система не обеспечит долговременное хранение, контроль целостности, независимую копию и успешный тест восстановления. Cutover разрешён только после периода параллельной работы и письменной фиксации критериев приёмки.

## Проверка

Проверяйте наличие ожидаемого свежего набора по каждому активному устройству, возраст последнего успешного backup, хеши артефактов и возможность восстановления. Сам факт успешной передачи файла недостаточен.

## Backlog: бэкдор SFTP / knockknock

**Проблема (anna canary, 2026-10-14):** публичный IP устройства (`/ip cloud public-address`) быстро попадает в бан SSH на CHR, если до установки `alist-fw-knockknock` или рядом с ним идут несколько `ssh-exec` / пачка мелких SFTP (`doSuperviseCHRviaSSH`, `doDumpTheScripts`, повторные probe). Типичный симптом — `action timed out` на `/system ssh-exec`, затем `sftp status: 20` / обрыв upload.

**Ложный SUCCESS у `$globalCallFetch`:** helper дожидается конца job и пишет протокол, но не возвращает ошибку при `status: failed` / `sftp status: 20`. Этот helper остаётся для FTP на localhost, HTTPS и HTTP POST. SFTP в `doDumpTheScripts` и `doBackup` идёт через `$globalCallSftp`: такие исходы — ошибка, на потолке 30 с job снимается. Контракт — [fetch](fetch.md).

**Дальше по конвейеру:** меньше сессий до открытия бэкдора; не смешивать Supervise/Dump/ручные probe без паузы. Один `/tool fetch` переносит один файл, пачку им не собрать. Цикл останавливается на `sftp-session-cut`. Выключенный sshfs в Dump — отдельный канал, не замена этой остановки.
