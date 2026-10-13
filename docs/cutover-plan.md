# План cutover на `mikroconf`

Этот документ не разрешает применение на устройствах. Rollout выполняется
отдельной задачей после публикации `Defm/mikroconf` и проверки canary.

Целевой GitHub-репозиторий: `Defm/mikroconf`. Fetch через relay:

`https://…@relay.usetheforce.io/Defm/mikroconf/master/src/scripts/`.

В исходниках пути уже переведены: `doFreshTheScripts` качает оттуда,
`doDumpTheScripts` выгружает в `REPO/raw/src/scripts/` (host `/REPO/raw` =
clone, Docker gitwatch → `_autobranch`). Binary backup — `REPO/backups/`;
rawconf — `REPO/raw/rawconf_*` (в working tree clone, не tracked).

## Предусловия

1. Remote `mikroconf` создан и опубликован; `master` защищён от прямого push.
2. Secret scan и `./tools/check-repository.sh` проходят на опубликованном commit.
3. Host `/REPO/raw` — clone `mikroconf` на `_autobranch`; контейнер gitwatch
   смонтирован на него; каталог `src/scripts/` доступен для записи dump;
   push идёт в `_autobranch`, не в `master`.
4. Все необходимые `$globalSecret` keys настроены на canary.
5. Доступен откат: старый URL `…/mikrobackups/master/scripts/` ещё отдаёт
   прежний набор; dump-путь легаси `REPO/raw/scripts/` ещё известен.
6. Есть проверенный text restore-export и binary backup canary.
7. Скрипты больше 4096 байт проверены отдельно: текущий `output=user` нельзя
   считать доказанно надёжным для них.

## Изменения в исходниках (уже в дереве)

- `doFreshTheScripts`: `gitHubRepoName=mikroconf`, path `master/src/scripts/`;
- `doDumpTheScripts`: SFTP/SSHFS target `REPO/raw/src/scripts/` (легаси было
  `REPO/raw/scripts/`);
- `doBackup`: без изменений (`REPO/backups/`, `REPO/raw/rawconf_*`);
- `UpdateList` в том же change не трогать попутно.

## Порядок на устройствах

1. Создать immutable backup и зафиксировать pre-state canary.
2. Вручную обновить только `doFreshTheScripts` на canary (или один полный
   refresh после публикации, если canary ещё на старом source).
3. Выполнить один refresh и сравнить source каждого allowlisted script.
4. Проверить dump → файлы в `/REPO/raw/src/scripts/` и commit gitwatch на
   `_autobranch`.
5. Проверить startup, connectivity, routing, DNS, VPN и logs.
6. Выдержать согласованный период наблюдения.
7. Повторять по одному устройству; CHR и основной router — последними.

## Ветка унификации канона

Унификация стиля (`unify-canon`, `docs/style-canon.md` раздел 4) ломает байтовое
сравнение первого refresh, если на `master` уже лежат унифицированные скрипты,
а на устройстве ещё старые. Поэтому:

- первый refresh после публикации сверяйте осознанно (хеш/diff), не ожидая
  байт-в-байт равенства со старым production;
- после принятия нового набора на каждом устройстве:
  `doEnvironmentClearance` → `doEnvironmentSetup` (или reboot → `doStartupScript`);
- в том же окне вручную переименовать event-глобалы netwatch/DHCP/hotspot
  (`NetwatchHostName` → `globalNetwatchHostName`, `Glease*` → `globalLease*`,
  `Guser` → `globalHotspotUser`). Иначе хуки выйдут по валидации с `:error`.

Откат унификации — вернуть предыдущие source из сохранённого text export
и заново прогнать `doEnvironmentClearance` → `doEnvironmentSetup`.

## Остановка и откат

Остановиться при fetch error, усечённом source, неожиданном script diff,
потере management/VPN/DNS или новых errors в logs. Откат — восстановить
`doFreshTheScripts` на `mikrobackups` / `master/scripts/` и source изменённых
скриптов из text export. Binary restore — только отдельная аварийная процедура.
