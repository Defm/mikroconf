# Аудит RouterOS-скриптов перед публикацией

Дата аудита: 2026-10-12. Область: только `src/scripts/*.rsc.txt` (44 файла).

## Итог

- Проверены все 44 файла поиском по шаблонам секретов и ручным просмотром чувствительных мест.
- Реальные литералы секретов удалены из 7 файлов. Функциональность, имена файлов, IP-адреса, домены и топология не скрывались.
- Для штатных скриптов секреты читаются через `$SECRET`; отсутствие записи приводит к ошибке, то есть операция закрывается безопасно. Для автономного `doPerfectRestore` требуется runtime-глобальная `CertificateImportPassphrase`, проверяемая до каких-либо действий.
- Секреты, требующие настройки: `BACKUP_PASSWORD`, `CERTIFICATE_EXPORT_PASSPHRASE`, `BANDWIDTH_TEST_USER`, `BANDWIDTH_TEST_PASSWORD`, `INFLUXDB_USER`, `INFLUXDB_PASSWORD`, `INFLUXDB_TOKEN`, `TELEGRAM_TOKEN`, `TELEGRAM_CHAT_ID`; отдельно для restore — `CertificateImportPassphrase`.
- Значения удалённых секретов здесь намеренно не приводятся.
- URL в `doFreshTheScripts` оставлен с путём `scripts/`: cutover на `src/scripts/` в этот аудит не входит.

## Provenance

41 файл — current-набор, скопированный в `src/scripts` до аудита. Историческая тройка восстановлена из дерева коммита `3f5b2a1ae0695d55b3161849859af79e77b4224b` старого репозитория:

- `doPeriodicLogDump.rsc.txt` — blob `e84aa867bccf85cd65d0c739fcebbd8a7a2ee26f`;
- `doPeriodicLogParse.rsc.txt` — blob `9c06d85ce113a7809977da5f4936e6df38997205`;
- `doTelegramNotify.rsc.txt` — исходный blob `30a346fac2e03b3abc0db7bee609dda2d148df85`; после удаления literal token/chat ID файл ожидаемо отличается.

До санитизации blob-хэши всех трёх файлов совпадали с указанным commit tree.

## Реестр 44 файлов

| Файл | Источник | Назначение | Риск | Обращение с секретами |
|---|---|---|---|---|
| `doAdblock.rsc.txt` | current | Загружает и применяет hosts/adblock-правила | Средний: внешние списки и массовая запись DNS | Секреты не обнаружены |
| `doBackup.rsc.txt` | current | Создаёт backup/export и отправляет по SFTP | Высокий: backup и внешняя передача | Уже использует `$SECRET`: `SSH_*` |
| `doBumerSound.rsc.txt` | current | Звуковая последовательность | Низкий | Секреты не обнаружены |
| `doCPUHighLoadReboot.rsc.txt` | current | Контролирует CPU и перезагружает при пороге | Высокий: автоматический reboot | Секреты не обнаружены |
| `doCertificatesIssuing.rsc.txt` | current | Выпускает CA/server/client/code-sign сертификаты и PKCS#12 | Высокий: создаёт и экспортирует private keys | Literal passphrase заменён на `$SECRET get CERTIFICATE_EXPORT_PASSPHRASE` |
| `doCheckPingRate.rsc.txt` | current | Контролирует задержку и уведомляет | Средний: сетевой мониторинг/оповещение | Секреты не обнаружены |
| `doCloudBackup.rsc.txt` | current | Создаёт и загружает RouterOS cloud backup | Высокий: полный backup | Literal password заменён на `$SECRET get BACKUP_PASSWORD` |
| `doCollectSpeedStats.rsc.txt` | current | Запускает двусторонний bandwidth-test | Высокий: активный нагрузочный тест | Credentials заменены на `BANDWIDTH_TEST_USER/PASSWORD` в `$SECRET` |
| `doCoolConsole.rsc.txt` | current | Оформляет console/system note | Низкий | Секреты не обнаружены |
| `doCreateTrafficAccountingQueues.rsc.txt` | current | Создаёт/чистит simple queues по DHCP | Средний: массово меняет queues | Секреты не обнаружены |
| `doDHCPLeaseTrack.rsc.txt` | current | Обрабатывает события DHCP lease | Средний: меняет сетевое состояние, запускает alarm | Секреты не обнаружены |
| `doDumpTheScripts.rsc.txt` | current | Выгружает скрипты на RAM/SFTP/SSHFS | Высокий: экспорт кода наружу | Уже использует `$SECRET`: `SSH_*` |
| `doEnvironmentClearance.rsc.txt` | current | Очищает глобальные переменные | Средний: сброс runtime-состояния | Секреты не обнаружены |
| `doEnvironmentSetup.rsc.txt` | current | Определяет общие функции, `$SECRET`, Telegram, SCEP, SSH | Высокий: центральная привилегированная библиотека | Существующие Telegram/SSH lookups сохранены; certificate export переведён на `CERTIFICATE_EXPORT_PASSPHRASE` |
| `doFastTrackActivation.rsc.txt` | current | Включает FastTrack-правило | Средний: влияет на firewall/учёт | Секреты не обнаружены |
| `doFlushLogs.rsc.txt` | current | Ротирует/очищает logs | Средний: удаление журналов | Секреты не обнаружены |
| `doFreshDNSAddressLists.rsc.txt` | current | Обновляет DNS/firewall address lists из внешних источников | Высокий: большие внешние списки | Секреты не обнаружены |
| `doFreshTheScripts.rsc.txt` | current | Обновляет RouterOS scripts из репозитория | Высокий: удалённая замена исполняемого кода | Пустой `GitHubAccessToken` — fail-closed placeholder; реального literal нет |
| `doHeatFlag.rsc.txt` | current | Обновляет температурный/heat flag | Средний: мониторинг состояния | Секреты не обнаружены |
| `doHotspotLoginTrack.rsc.txt` | current | Обрабатывает hotspot login event | Средний: hook с глобальным состоянием | Секреты не обнаружены |
| `doIPSECPunch.rsc.txt` | current | Мониторит и восстанавливает IPSec/L2TP | Высокий: управляет VPN-сессиями | Секреты не обнаружены |
| `doImperialMarch.rsc.txt` | current | Звуковая последовательность при старте | Низкий | Секреты не обнаружены |
| `doKeepScriptsOwner.rsc.txt` | current | Выравнивает owner scripts/schedulers через локальный FTP import | Высокий: меняет владельцев и policy | Password формируется во время выполнения; literal отсутствует |
| `doLEDoff.rsc.txt` | current | Выключает LED | Низкий | Секреты не обнаружены |
| `doLEDon.rsc.txt` | current | Включает LED | Низкий | Секреты не обнаружены |
| `doNetwatchDNS.rsc.txt` | current | Обрабатывает Netwatch и переключает DNS entries | Средний: динамически меняет DNS | Секреты не обнаружены |
| `doNetwatchHost.rsc.txt` | current | Обрабатывает Netwatch host up/down | Средний: hook/уведомления | Секреты не обнаружены |
| `doPerfectRestore.rsc.txt` | current | Импортирует backup, сертификаты, users и SSH keys, затем reboot | Критический: полный restore и учётные записи | Certificate literal удалён; обязательна непустая runtime `CertificateImportPassphrase`, иначе ранняя ошибка |
| `doPeriodicLogDump.rsc.txt` | historical trio | Читает/очищает log buffer и вызывает parser | Высокий: очищает buffer и передаёт log data | Секреты не обнаружены |
| `doPeriodicLogParse.rsc.txt` | historical trio | Анализирует login/config log events и уведомляет | Средний: обрабатывает security-события | Секреты не обнаружены |
| `doPushStatsToInfluxDB.rsc.txt` | current | Отправляет queue/bandwidth telemetry в InfluxDB | Высокий: внешний write API и активный test | Basic credentials, token и bandwidth credentials переведены на `$SECRET` |
| `doRandomGen.rsc.txt` | current | Генерирует и устанавливает пароль reserve user | Высокий: меняет privileged credential | Пароль генерируется runtime; literal секрета отсутствует |
| `doSCEPClientCertificatesIssuing.rsc.txt` | current | Создаёт SCEP client request | Высокий: сертификаты и внешняя CA | Секретные literals не обнаружены |
| `doSomeAlarm.rsc.txt` | current | Звуковой alarm | Низкий | Секреты не обнаружены |
| `doStaleTSLConnectionsTrack.rsc.txt` | current | Ищет stale TLS connections и ведёт address list | Средний: меняет firewall address list | Секреты не обнаружены |
| `doStartupScript.rsc.txt` | current | Ждёт NTP и запускает startup-цепочку | Высокий: оркестрация boot | Секреты не обнаружены |
| `doSuperviseCHRviaSSH.rsc.txt` | current | Управляет удалённым CHR по SSH | Высокий: remote privileged operations | Рассчитан на SSH keys; literal password отсутствует |
| `doTelegramNotify.rsc.txt` | historical trio | Отправляет Telegram message | Высокий: внешний bot API | Token и chat ID заменены на `TELEGRAM_TOKEN/CHAT_ID` в `$SECRET` |
| `doTranstaleMAC2IP.rsc.txt` | current | Преобразует MAC в IP/hostname | Низкий | Секреты не обнаружены |
| `doUpdateExternalDNS.rsc.txt` | current | Обновляет внешний DNS и запускает CHR supervision | Высокий: DNS/VPN orchestration | Секреты не обнаружены |
| `doUpdatePoliciesRemotely.rsc.txt` | current | Применяет IPSec policies по remote runtime-параметрам | Высокий: меняет VPN policy | Секреты не обнаружены |
| `doUpdateStaticDNSviaDHCP.rsc.txt` | current | Синхронизирует static DNS с DHCP leases | Средний: массово меняет DNS | Секреты не обнаружены |
| `doWestminister.rsc.txt` | current | Звуковая последовательность | Низкий | Секреты не обнаружены |
| `flush_dns.rsc.txt` | current | Очищает DNS cache | Низкий | Секреты не обнаружены |

## Файлы больше 4096 байт

Размеры после санитизации:

- `doBackup.rsc.txt` — 6027;
- `doCertificatesIssuing.rsc.txt` — 4547;
- `doCoolConsole.rsc.txt` — 4445;
- `doDumpTheScripts.rsc.txt` — 7093;
- `doEnvironmentSetup.rsc.txt` — 21478;
- `doFreshDNSAddressLists.rsc.txt` — 13408;
- `doIPSECPunch.rsc.txt` — 19572;
- `doKeepScriptsOwner.rsc.txt` — 5374;
- `doPerfectRestore.rsc.txt` — 11576;
- `doPeriodicLogDump.rsc.txt` — 4464;
- `doPushStatsToInfluxDB.rsc.txt` — 4867.

`doFreshTheScripts` получает весь `source` через `fetch output=user` и сам предупреждает о пороге 4096. Для перечисленных файлов это риск усечения/неполного обновления; исправление механизма обновления отложено как отдельное behavioral change.

## Drift `UpdateList`

В `doFreshTheScripts` перечислены 22 имени из 44. Вне списка остаются:

`doAdblock`, `doBumerSound`, `doCheckPingRate`, `doCollectSpeedStats`, `doCreateTrafficAccountingQueues`, `doDHCPLeaseTrack`, `doDumpTheScripts`, `doFastTrackActivation`, `doFreshDNSAddressLists`, `doHotspotLoginTrack`, `doImperialMarch`, `doKeepScriptsOwner`, `doNetwatchDNS`, `doPerfectRestore`, `doPushStatsToInfluxDB`, `doSCEPClientCertificatesIssuing`, `doSomeAlarm`, `doStaleTSLConnectionsTrack`, `doTranstaleMAC2IP`, `doUpdateStaticDNSviaDHCP`, `doWestminister`, `flush_dns`.

Дополнительно перед `doIPSECPunch` в строке списка есть пробел. В зависимости от поведения `:toarray`/`find` это может препятствовать совпадению. Список и matching logic не менялись, поскольку это отдельное behavioral finding.

## Scheduler-only и другие точки входа

По сохранённым конфигурациям и связям между скриптами scheduler-driven, без прямого вызова из другого файла набора: `doBackup`, `doCPUHighLoadReboot`, `doCheckPingRate`, `doCloudBackup`, `doCollectSpeedStats`, `doCreateTrafficAccountingQueues`, `doFlushLogs`, `doFreshDNSAddressLists`, `doFreshTheScripts` (не на всех устройствах), `doHeatFlag`, `doIPSECPunch`, `doLEDoff`, `doLEDon`, `doRandomGen`, `doStaleTSLConnectionsTrack`, `doUpdateStaticDNSviaDHCP`. `doUpdateExternalDNS` также запускается scheduler, но вызывает `doSuperviseCHRviaSSH`; `doCoolConsole` запускается и scheduler, и startup.

Не scheduler-only:

- event hooks: `doDHCPLeaseTrack`, `doHotspotLoginTrack`, `doNetwatchDNS`, `doNetwatchHost`;
- startup entry: `doStartupScript`;
- цепочка log parser: `doPeriodicLogDump` → `doPeriodicLogParse`;
- remote/RPC target: `doUpdatePoliciesRemotely`;
- прочие — manual/library/utility либо вызываются другими скриптами.

## Оставленные behavioral findings

В соответствии с границами аудита они не исправлялись:

- `doPerfectRestore` создаёт main admin с пустым password и пишет runtime-generated credentials в log;
- `$SECRET print` в `doEnvironmentSetup` показывает сохранённые passwords;
- `doRandomGen` логирует сгенерированный password и отправляет его часть;
- часть telemetry/SCEP endpoint использует HTTP;
- `doFreshTheScripts` имеет drift списка, старый URL path и ограничение больших source;
- статическая проверка баланса обнаруживает дополнительную закрывающую `}` в `doPeriodicLogDump`, `doPeriodicLogParse` и `doSCEPClientCertificatesIssuing`; это существующее состояние, не внесённое санитизацией.

## Проверки

- Pattern scan: password/passphrase/token/authorization/private-key/API-key, Telegram token shape, длинные credential-like строки и PEM markers.
- Ручной review всех совпадений: runtime variables, примеры и пустые placeholders отделены от реальных literals.
- В 7 изменённых scripts число `{`/`}` совпадает, число двойных кавычек чётное.
- RouterOS interpreter в репозитории отсутствует; проверка синтаксиса была статической и осторожной.
- Коммит не создавался.
