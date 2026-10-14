# Fetch и `$globalCallSftp`

Ориентир для SFTP-upload. Пол версии метода — RouterOS не ниже 7.24. Отчёт upload из 7.25 («improve upload state reporting when using sftp») не используется. Это описание текущего контракта `$globalCallSftp`, не задел на следующую переделку `$globalCallFetch`.

Источник поведения `/tool fetch` — [Fetch](https://manual.mikrotik.com/docs/system-information-and-utilities/fetch).

## Почему старый helper врёт

`$globalCallFetch` в `doEnvironmentSetup` не вызывает `/tool fetch` в том же скрипте. Он кладёт строку команды в `[:execute file=RAM/….log.txt]`, до 30 секунд смотрит, жив ли job, и печатает протокол через `$globalNoteMe`. На `status: failed` и `sftp status: 20` функция не возвращает ошибку. Вызывающий код ловит только throw, поэтому Dump и Backup могли отчитаться `✓ SUCCESS`.

Тот же helper пишет в лог всю строку команды, включая `password=`. Счётчик ожидания — общий глобал `globalFetchWaitTicks`. Потолок 30 с job не снимает: сессия остаётся.

`$globalCallFetch` в этом заходе не переписан. Через него по-прежнему идут:

- FTP на `127.0.0.1` в `doKeepScriptsOwner`;
- HTTPS-скачивание и `:import` в `doFreshDNSAddressLists`;
- HTTP POST bandwidth в `doPushStatsToInfluxDB`.

Прямые вызовы, которые helper не оборачивает: `doFreshTheScripts` (`output=user as-value`), `doAdblock` (проверка файла после fetch), `globalTgMessage` (`keep-result=no`), проверка `last-status` у почты в `doBackup`. Локальный `waitForFile` в `doFreshDNSAddressLists` ждёт появления скачанного файла и к SFTP-upload не относится.

## `$globalCallSftp`

Один файл за вызов. Списка, маски и каталога у `/tool fetch` нет. Запись changelog 7.24 «hint file list» — подсказка имён в консоли. Собрать пачку в один fetch нельзя.

Аргументы позиционные: `$1` = локальный `src`, `$2` = удалённый `dst` (имена `src=`/`dst=` внутри `:global do=` на полевом 7.x приходили пустыми). Сервер, порт, пользователь и пароль метод берёт из `$globalSecret` (`SSH_SERVER`, `SSH_PORT`, `SSH_USER`, `SSH_PASSWORD`). Пароль в `$globalNoteMe` не пишется.

Запуск — фоновый `[:execute file=…]` с `idle-timeout=30s` на самом fetch. Родитель до 30 секунд раз в секунду пишет `waiting Ns` и читает протокол. `:parse` и синхронный fetch здесь не используются: на 7.24 номер `sftp status` виден в консольном протоколе, а не в карте `as-value`.

Контракт как у `$globalCallSSH`: `""` при успехе, иначе текст ошибки.

Два исхода, в которых `$globalCallFetch` молчит, здесь всегда ошибка:

- Job уже исчез, в протоколе `status: failed`, `sftp status: 20`, `timed out` или `timeout`. Возврат начинается с `sftp-session-cut` и содержит протокол. Job уже кончился, снимать нечего.
- Прошло 30 с, job ещё есть. Сначала `/system script job remove` по id от `:execute`, затем `sftp-session-cut still running after …`. Сессия после потолка не остаётся. Передача, которая на 30-й секунде ещё идёт, обрывается.

Остальные ветки того же цикла:

- В протоколе есть `status: finished` и нет признаков провала. Возврат `""`.
- Job исчез, протокола нет или в нём нет `status: finished`. Возврат `sftp upload failed` и имеющийся текст. Это ошибка одного файла: цикл идёт дальше, `itsOk` становится false.

`doDumpTheScripts` и `doBackup` на префиксе `sftp-session-cut` ставят `stopBatch` и не открывают следующие SFTP. Обычная ошибка файла цикл не останавливает. В `doBackup` локальный файл снимается только после пустого ответа метода (если SFTP выключен, почтовый путь по-прежнему удаляет файл). Проверки, что файл уже лежит на CHR, нет: её не было и у старого helper.

`sftp status: 20` не читается как errno. Натурно (anna → CHR, отсутствующий `REPO/raw/___no_such_dir___/`): протокол fetch —

```
status: uploading   uploaded = total
status: failed
failure: closing connection: <sftp status: 20> … (/tool/fetch; line 1)
```

Тот же текст бывает после бана SSH. Fetch **не** создаёт remote-каталоги. `$globalCallSftp` при failed / status 20 / timeout дописывает короткий hint: remote parent dir / SSH ban.

## Что fetch умеет на 7.24 и чего нет в 7.25

На поле 7.24 уже есть `idle-timeout` (починка случаев, когда он не срабатывал, вошла в 7.23), разбор HTTP-ошибок в `:onerror` с 7.22 и молчаливый обрез `output=user` на 64512 байт. Порог 4096 в аудите — не этот лимит: это потолок `/file add` (4095) и старое предупреждение. Обрезка `output=user` ошибки не бросает; для будущего `doFreshTheScripts` ориентир — считать ошибкой длину тела ровно 64512.

В код не закладывается поведение только из 7.25: улучшенный отчёт SFTP-upload, запрет cookie jar, более ясная ошибка при `keep-result` вместе с `output`.

Один вызов переносит один файл. Меньше сессий на Dump — это останов цикла после `sftp-session-cut` и выключенный путь sshfs (`useSshfs`), не один fetch на пачку.

## Чужие репозитории

Ранжирование на 2026-10-14, публичные репозитории, чей основной артефакт — скрипты RouterOS. Клиенты API и Terraform не считались.

1. [eworm-de/routeros-scripts](https://github.com/eworm-de/routeros-scripts) — 1874 звезды. В метод взято одно правило: успех — это `status: finished`, иначе это ошибка. Синхронный `/tool fetch` без протокола не взят: на 7.24 номер `sftp status` живёт в консоли job.
2. [beeyev/Mikrotik-RouterOS-automatic-backup-and-update](https://github.com/beeyev/Mikrotik-RouterOS-automatic-backup-and-update) — 624 звезды. Тот же приём уже есть у почты в `doBackup`: смотреть `last-status`, а не факт возврата команды. Для SFTP роль `last-status` играет протокол.
3. [misterkrittin/Scripts-MikroTik](https://github.com/misterkrittin/Scripts-MikroTik) — 385 звёзд. Брать нечего: успех пишется сразу после вызова.

Не переносится каркас eworm, монолит beeyev, `check-certificate=no` как норма, HTTP/2 и любое поведение из 7.25.

Позже, не в этом контракте: вынуть `:import` из `$globalCallFetch`; bandwidth POST сделать таким же прямым fetch, как поочередевой POST в `doPushStatsToInfluxDB`.
