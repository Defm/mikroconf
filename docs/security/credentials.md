# Учётные данные

## Правила

- Значения credentials никогда не хранятся в Git, документации, inventory, URL или аргументах команд.
- RouterOS-скрипты получают значения через локальную функцию `$SECRET`.
- Passphrase для recovery вводится оператором во время процедуры и не записывается в source.
- Для каждого назначения используется отдельный credential с минимальными правами.
- Логи содержат только имя операции и результат, но не собранную command string.

## Имена, а не значения

Допустимо документировать только логические ключи: `SSH_SERVER`, `SSH_PORT`, `SSH_USER`, `SSH_PASSWORD`, `BACKUP_PASSWORD`, `TELEGRAM_TOKEN`, `TELEGRAM_CHAT_ID`, `CERTIFICATE_EXPORT_PASSPHRASE`, `INFLUXDB_PASSWORD`.

## Диагностический доступ

Локальные файлы:

```text
~/.config/mikrobackups/inventory.yml
~/.ssh/mikrobackups/cursor-diag
~/.ssh/mikrobackups/cursor-diag.pub
~/.ssh/mikrobackups/known_hosts
```

Права каталогов — `0700`, private key и inventory — `0600`. Inventory
содержит только aliases устройств, адреса, пользователя `cursor-diag`, путь к
private key и путь к выделенному `known_hosts`; passwords в нём не нужны.

На RouterOS используется отдельная группа с минимальными policy `ssh,read`.
Не используйте административного пользователя как постоянный credential MCP.
Host fingerprint проверяется оператором по независимому каналу до записи в
`known_hosts`; автоматическое доверие первому ключу запрещено.

## Ротация

При подозрении на утечку сначала отзовите или смените credential в целевой системе, затем обновите локальные secret stores на устройствах и проверьте использование. Очистка Git-истории не заменяет ротацию.

## Проверка

Перед release просмотрите diff и запустите локальный quality-check. Автоматическая проверка не обнаруживает все форматы секретов; строки, похожие на token, key, passphrase или credential, требуют ручной оценки.
