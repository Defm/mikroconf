# 002-remove-common-ports: проектное решение

## Контекст

`chain-self-common-ports` стоит поздно в `input` и принимает каталог портов
без источника. Часть нужных сервисов уже закрыта точечно
(`chain-ssh-staged-control`, `chain-router-services-*`, `chain-dns-amp-attack`,
`chain-vpn-rules`, SMB allow-list). DHCP 67/68 и NTP 123 на anna сегодня
приняты только через этот каталог: после удаления без замены сломаются
lease и NTP clients.

Guest и netinstall не входят в `list-trusted`, поэтому одного trusted-list
для DHCP/NTP недостаточно.

## Решение

1. Упразднить каталог целиком, не вычищать поштучно.
2. Новые разрешения только через jump-цепочки:
   `chain-dhcp-server`, `chain-ntp-server` (даже из одного accept).
3. Ограничение интерфейсов — новый `list-router-input-services` с четырьмя
   bridge dhcp-server; без WAN и без новых address-list.
4. Порядок выката: сначала добавить list + цепочки + jump, затем disable
   jump в common-ports, наблюдение, remove цепочки. Снимок `*.safe.rsc`
   агент не обновляет.
5. **Раскладка filter:** правила одной цепочки — непрерывным блоком
   `jump → тело → return`, без чередования с правилами другой цепочки в
   общем списке `/ip firewall filter`. При добавлении нескольких цепочек
   сначала полностью собрать одну (тело + return), затем другую; при
   нарушении порядка — `move` до приёмки.
6. **Регресс 443:** каталожный accept `port=443` кормил reverse-proxy
   (SNI → victoria / wiren / sprut / metrics / netro). Замена —
   `chain-reverse-proxy`, не каталог. Служба
   `available-from=192.168.90.0/24` — accept в цепочке с тем же
   `src-address` (не шире службы). Эскиз (на устройство только с «да»):

   ```
   /ip firewall filter
   add chain=input action=jump jump-target=chain-reverse-proxy \
       protocol=tcp dst-port=443 comment="jump reverse-proxy"
   add chain=chain-reverse-proxy action=accept protocol=tcp dst-port=443 \
       src-address=192.168.90.0/24 comment="clients to reverse-proxy"
   add chain=chain-reverse-proxy action=return
   ```

   Прямые dstnat :9428/:7575 — forward; UI `https://*.anna.home` = input :443.

## Критика комментариев accept (не править на устройстве в этом шаге)

На anna сейчас:

| Правило | comment сейчас | Проблема |
| --- | --- | --- |
| accept в `chain-dhcp-server` | `Accept DHCP server` | Читается как «принимаем DHCP-сервер». На самом деле input принимает **обращения клиентов к сервису** dhcp-server на anna (UDP 67/68). Сервер уже здесь; filter не «принимает сервер». |
| accept в `chain-ntp-server` | `Accept NTP server` | То же: принимаем **клиентские запросы к NTP-сервису** anna, не «NTP server» как субъект. |
| jump | `Jump to DHCP/NTP Server Chain` | Терпимо (указатель на цепочку), но тяжёлый английский; смысл jump ясен из `jump-target`. |

Имя цепочки `chain-<сервис>-<роль>` (`chain-dhcp-server`, `chain-ntp-server`) как у SSH — **ок**: роль сервиса на роутере. Путаница в **comment accept**, не в имени chain.

Канон comment для таких accept (вперёд, в т.ч. 443; rename DHCP/NTP — отдельным шагом с «да»):

- писать **кто → какой сервис**, не «Accept \<server\>»;
- примеры: `DHCP clients to server`, `NTP clients to server`,
  `reverse-proxy clients` / `clients to reverse-proxy`;
- короткий служебный ярлык без «Accept … server»;
- не дублировать имя chain дословно, если comment врёт о направлении.

Эскиз 443 — `jump reverse-proxy` / `clients to reverse-proxy`.
Шаг 8.2 выполнен (2026-11-24): на anna comments переименованы; soak
читает counters через `/ip firewall filter get … packets` по новым
comment (не через разбор `print stats`).

## Отвергнутые альтернативы

- Оставить «полезный» хвост каталога — снова каталог; дыры (Winbox/VPN-порты)
  остаются.
- Голые `accept` прямо в `input` — против договорённости «всё через цепочки».
- `in-interface-list=list-trusted` alone — ломает guest и netinstall DHCP/NTP.
- Новые `alist-fw-dhcp-*` / knock — лишняя сложность; сервисы локальные.

## Риски

- Пропуск bridge в list — нет lease/NTP на сегменте. Снижаем: явный список
  из текущих dhcp-server; проверка lease на каждом сегменте.
- Слишком раннее удаление common-ports до новых jump — краткий outage DHCP.
  Снижаем: add → disable → observe → remove.
- Регресс management и смежников (SSH/Winbox/DNS/SMB/VPN/CAP/proxy и трафик,
  который раньше ел каталог) — точечные цепочки не покрывают весь IANA-список;
  нужны **бдительные и длительные** тесты по чеклисту смежников в
  `proposal.md` (smoke сразу + наблюдение за период эксплуатации) и просмотр
  `#DROP UNKNOWN (INPUT)` до `/sdd-verify` / archive.
