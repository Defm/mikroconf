# Диагностика

## Безопасный порядок

1. Зафиксируйте устройство, время и наблюдаемый симптом.
2. Сначала используйте локальные артефакты и read-only данные.
3. Не публикуйте полные логи, exports, адреса управления и credentials.
4. Перед удалённой диагностикой получите явное разрешение оператора.
5. Не совмещайте сбор данных и исправление.

## Локальный MCP-контур

Cursor запускает два локальных stdio-сервера из `.cursor/mcp.json`:

- `rosetta` — офлайн-справка RouterOS из `vendor/rosetta`;
- `mikrotik-readonly` — усиленная локальная копия
  `vendor/mikrotik-mcp`.

Подготовка среды:

```sh
brew install bun uv
cd vendor/rosetta && bun install --frozen-lockfile
cd ../mikrotik-mcp && uv sync
```

База Rosetta хранится в ignored `.cache/rosetta/ros-help.db`. После загрузки
MCP запускается с `ROSETTA_OFFLINE=1`.

MikroTik MCP читает inventory из
`~/.config/mikrobackups/inventory.yml`, а доверенные SSH host keys — из
`~/.ssh/mikrobackups/known_hosts`. Не копируйте эти файлы в workspace.
В inventory указаны пользователь `automation` и ключ
`~/.ssh/mikrobackups/automation`. Каталог MCP остаётся read-only, но SSH-аккаунт
на устройстве привилегированный: write-команды по-прежнему режет hook и
hardened allowlist, least-privilege пользователя `cursor-diag` это не заменяет.

Локальная готовность (без SSH):

```sh
./tools/check-mcp-readonly.sh
```

Пустой `known_hosts` — ожидаемый fail-closed: hardened-клиент использует
только этот файл и `RejectPolicy`. Закрепляйте ключ по заранее известному
fingerprint, не копируйте `~/.ssh/known_hosts` и не принимайте
непроверенный `ssh-keyscan`:

```sh
./tools/pin-host-key.sh <host> SHA256:<fingerprint>
```

В `.cursor/mcp.json` для `mikrotik-readonly` явно заданы
`MIKROTIK_PROFILE=hardened-read-only`, `MIKROTIK_READ_ONLY=true`,
`MIKROTIK_SENSITIVE_HIDING=true` и `stdio`. Launcher всё равно принудительно
ставит те же значения; дублирование в env не даёт ослабить профиль, если
команду сменят на обычный `mcp-server-mikrotik`.

Hardened-профиль:

- использует только `stdio`;
- требует `read_only=true` и `sensitive_hiding=true`;
- принимает только известные SSH host keys;
- экспортирует только локально проверенный allowlist read-tools;
- не предоставляет file/backup download, sniffer, torch, flood,
  bandwidth/load и write/destructive operations.

## Bootstrap диагностического пользователя

Сначала просмотрите план:

```sh
./tools/bootstrap-readonly.sh plan capxl automation
```

Apply разрешён только после независимой проверки SSH fingerprint и отдельного
подтверждения для конкретного устройства. Скрипт требует одновременно
`MIKROBACKUPS_BOOTSTRAP_APPROVED=<host>`, существующий admin key в
`ADMIN_IDENTITY_FILE` и уже закреплённый host key. Он создаёт только группу
`cursor-diag-readonly` с policy `read,ssh`, пользователя `cursor-diag` и его
выделенный SSH key.

Если fingerprint не подтверждён, не добавляйте результат `ssh-keyscan` в
`known_hosts` и не выполняйте apply.

## Backup не появился

- проверьте последнее сообщение `doBackup` без вывода command strings с credentials;
- убедитесь, что устройство на основном partition;
- проверьте доступность локального secret store и внешнего storage;
- сравните время на устройстве и ожидаемый scheduler;
- проверьте, не остались ли временные файлы после ошибки.

## Скрипт не обновился

- проверьте точное имя и наличие в update list;
- подтвердите текущий release path (`mikroconf` / `master/src/scripts`, либо ещё старый `mikrobackups` / `master/scripts`);
- сравните размер загруженного source, особенно около ограничения `output=user`;
- убедитесь, что ошибка одного скрипта не остановила весь цикл;
- не запускайте массовое обновление для диагностики.

## Расхождение raw и curated source

Считайте raw чувствительным свидетельством, а не готовым patch. Сравнивайте локально, удаляйте secrets и device-specific state, затем переносите только осознанное изменение в `src/scripts`.
