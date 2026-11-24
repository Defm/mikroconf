# 002-remove-common-ports: шаги

## 1. Подготовка на anna

- [x] 1.1 Создать `interface list` `list-router-input-services` и member:
  `main-infrastructure-br`, `guest-infrastructure-br`,
  `docker-infrastructure-br`, `adm-netinstall-br`.
  Проверка: `/interface list print where name=list-router-input-services`;
  members — четыре bridge, без WAN.
  Требует подтверждения: запись на RouterOS-устройстве anna.
- [x] 1.2 Добавить `chain-dhcp-server` (accept UDP 67,68 с
  `in-interface-list=list-router-input-services`) и jump из `input`
  comment `Jump to DHCP Server Chain`.
  Проверка: `print where chain=chain-dhcp-server or jump-target=chain-dhcp-server`.
  Требует подтверждения: запись на RouterOS-устройстве anna.
- [x] 1.3 Добавить `chain-ntp-server` (accept UDP 123 с тем же list) и jump
  из `input` comment `Jump to NTP Server Chain`.
  Проверка: `print where chain=chain-ntp-server or jump-target=chain-ntp-server`.
  Требует подтверждения: запись на RouterOS-устройстве anna.

## 2. Снятие каталога

- [x] 2.1 Disable jump `Jump to "Manage Common Ports" Chain`, наблюдение
  counters DHCP/NTP и management.
  Проверка: jump disabled; lease/NTP/SSH/Winbox живы.
  Требует подтверждения: запись на RouterOS-устройстве anna.
- [x] 2.2 Remove jump и все правила `chain-self-common-ports`.
  Проверка: `print where chain=chain-self-common-ports` и
  `jump-target=chain-self-common-ports` пусты.
  Требует подтверждения: запись на RouterOS-устройстве anna.

## 3. Проверка репозитория

- [x] 3.1 `./tools/check-repository.sh` и `git diff --check`.
  Проверка: ожидаемые результаты команд; замечания только заранее известные.
  Снимок `src/config/anna.safe.rsc` не обновлять.

## 4. Правки по /sdd-verify

- [x] 4.1 Повторно снять counters DHCP/NTP на anna: DHCP accept>0, NTP accept>0;
  common-ports = 0. Лишний NTP jump без accept — трафик вне
  `list-router-input-services` (ожидаемо drop дальше по input).
  Проверка: `/ip firewall filter print stats where chain=chain-dhcp-server or chain=chain-ntp-server or jump-target=chain-dhcp-server or jump-target=chain-ntp-server`; count-only common-ports = 0.
- [x] 4.2 Синхронизировать `plan.md` с `tasks.md` (todos completed, статус
  in-progress) и убрать из `design.md` требование обновлять safe.rsc агентом.
  Проверка: frontmatter todos и п.4 `design.md` согласованы с proposal.

## 5. Бдительные и длительные тесты смежников

По плану стабильности в `proposal.md` (T0 → T+1 ч → T+24 ч, таблица pass/fail).

- [x] 5.1 **T0 smoke:** baseline на anna (counters DHCP/NTP, common-ports=0,
  VPN/CAP/OSPF) + клиентская телеметрия с **capxl** (lease/NTP/DNS/CAP к anna).
  Проверка: все Pass-строки таблицы для T0.
  Требует подтверждения: диагностика на anna и capxl (read-only).
  Результат T0 (2026-11-23 ~22:33 MSK): common-ports=0; DHCP accept=4 /
  jump=21; NTP accept=4 / jump=556; leases bound=14; chr-tunnel running;
  OSPF neighbor=1; capxl dhcp bound к anna, NTP synchronized к anna,
  DNS peer=anna. WiFi registration на anna в этом снятии = 0 (уточнить на
  T+1 при необходимости).
- [x] 5.2 **T+1 ч:** повтор counters на anna; выборка `#DROP UNKNOWN (INPUT)`;
  повтор клиентских проверок с capxl.
  Проверка: нет Fail по таблице за интервал T0…T+1 ч.
  Автономно: строка в `soak/TELEMETRY.md` около T0+1ч; подтверждения на тики
  сняты оператором до 2026-11-24 22:23.
  Результат T+1 (2026-11-23 23:45 MSK): pass; common=0; DHCP 11/45;
  NTP 13/719; leases=14; OSPF=1; tunnel running; drop_log=0; capxl
  dhcp=bound, ntp=synchronized. Sample `20261123-234527.md`.
- [x] 5.3 **Итог soak (ранний stop):** оператор остановил runner
  2026-11-24 11:07 MSK (~12.4 ч вместо полного T+24). Сводка pass/fail в
  `proposal.md` («Итог soak (ранний stop)»); финальный sample
  `20261124-110707.md`. DHCP/NTP/OSPF/tunnel/capxl — Pass; :443 — Fail
  (известный); парсер NTP jump — долг.
  Проверка: TELEMETRY + proposal; config не меняли.
- [x] 5.4 Почасовой сбор: runner остановлен по запросу оператора; строки
  TELEMETRY до 11:07 включительно; `SOAK_RUNNER stopped-by-operator` в
  `runner.log`.
  Проверка: процесс не жив; таблица закрыта итогом.

## 6. Раскладка цепочек (после soak / вместе с 443)

- [x] 6.1 Привести `chain-dhcp-server`, `chain-ntp-server` и
  `chain-reverse-proxy` к непрерывному блоку
  `jump → тело → return` без разрыва чужой цепочкой; явный `return`.
  Проверка: в `/ip firewall filter print` подряд перед SMB-input:
  dhcp → ntp → reverse-proxy; каждая тройка непрерывна.
  Требует подтверждения: запись на RouterOS-устройстве anna.
  Результат 2026-11-24: блок `*F3…*F8` перед `*E5` SMB; returns добавлены.

## 7. Reverse-proxy TCP/443 (Containers over reverse-proxy)

- [x] 7.1 В spec зафиксировать цепочку (имя `chain-reverse-proxy`): jump из
  `input` tcp dst-port=443 → accept с ограничением как у службы
  (`available-from` / LAN bridge / list) → return; без нового allow-list
  knock; блок непрерывный.
  Проверка: текст в proposal/design/delta согласован.
- [x] 7.2 Выкатить цепочку на anna после явного подтверждения; smoke
  `https://victoria.anna.home` и `https://netro.anna.home`; в логе нет
  LAN SYN→:443 `#DROP UNKNOWN`.
  Проверка: URL открываются; filter print; log.
  Требует подтверждения: запись на RouterOS-устройстве anna.
  Результат 2026-11-24: `src-address=192.168.90.0/24`; smoke
  netro→HTTP 200, victoria→HTTP 400 (бэкенд, не DROP); accept packets>0;
  свежих DROP :443 в логе нет.
- [x] 7.3 Отдельно проверить риск SMB :445 и FTP :21 (доступ / нужность);
  при необходимости завести follow-up, не раздувая 443.
  Проверка: заметка в proposal или новый шаг; device только с «да».
  Результат: FTP service **enabled**, input accept :21 нет (только
  ftp-block drop) — follow-up: disable ftp если не нужен. SMB enabled,
  filter input 137–139, **нет** :445 — follow-up при использовании шары.
  В этом изменении не меняли.

## 8. Comment accept

- [x] 8.1 Зафиксировать критику `Accept DHCP/NTP server` и канон
  `clients to <service>` в design/proposal/delta.
  Проверка: разделы в spec; на anna comments без изменений.
- [x] 8.2 После подтверждения: rename comment DHCP/NTP + обновить
  парсер `soak/collect-once.sh` под новые строки; при желании
  упростить jump comments.
  Проверка: print comments; collect-once читает counters.
  Требует подтверждения: запись на RouterOS-устройстве anna.
  Результат: comments `jump dhcp-server` / `DHCP clients to server` /
  `jump ntp-server` / `NTP clients to server`; парсер — `get packets`.

## 9. Правки по /sdd-verify (2026-11-24)

- [x] 9.1 Доказать раскладку 6.1 полным `filter print` (позиции 132–140
  подряд). Номера из `print stats where` (0/1/52…) **не** использовать как
  критерий непрерывности — они вводят в заблуждение.
  Проверка: [`evidence/filter-layout-20261124.md`](evidence/filter-layout-20261124.md).
- [x] 9.2 Сохранить evidence `chain-reverse-proxy` + list members в change.
  Проверка: [`evidence/reverse-proxy-20261124.md`](evidence/reverse-proxy-20261124.md).
- [x] 9.3 Синхронизировать proposal (критерии `[x]`, устаревшие абзацы),
  design, delta, plan todos 5.2/5.3; убрать stale `soak/runner.pid`.
  Проверка: нет противоречий «comments не трогаем» / «443 открыт» /
  plan pending vs tasks `[x]`.
