# 002-remove-common-ports: упразднение каталога common-ports на anna

Статус: archived

## Зачем

На `anna` в `input` стоит `chain-self-common-ports` — 92 правила (~39% filter),
каталог портов IANA с безусловным `accept`. Это не политика: нет ограничения
по источнику/интерфейсу, дубли и перебивают уже существующие цепочки
(SSH/Winbox staged, DNS amp, VPN, LAN-services, SMB). Реально нужны только
сервисы роутера; трекать каждый порт бессмысленно.

## Что меняется

- На `anna` удаляются jump и вся `chain-self-common-ports` (92 правила).
- До снятия добавляются jump-цепочки `chain-dhcp-server` и `chain-ntp-server`
  (даже по одному accept), имена в стиле `chain-<сервис>-<роль>`.
- Новый `interface list` `list-router-input-services` с bridge, где есть
  dhcp-server / клиенты NTP к anna: `main-infrastructure-br`,
  `guest-infrastructure-br`, `docker-infrastructure-br`, `adm-netinstall-br`.
  WAN в список не входит.
- Без новых knock / staged / address-list для DHCP и NTP.
- Существующие `alist-fw-ssh-*`, `alist-fw-smb-allow`, `alist-fw-dns-allow`,
  `alist-fw-vpn-*` не меняются.
- Снимок `src/config/anna.safe.rsc` агент не обновляет (пишет backup/оператор).
- Правила **одной** custom-цепочки в filter идут **подряд**, без вкрапления
  правил другой цепочки: `jump` (из caller) → тело цепочки → `return`
  (явный или конец цепочки). Новые цепочки оформлять и при необходимости
  переставлять так, чтобы блоки не чередовались.
- Подготовить (и после подтверждения выкатить) jump-цепочку для **TCP/443**
  — Containers over reverse-proxy (`chain-reverse-proxy` или согласованное
  имя в стиле `chain-<сервис>-<роль>`): accept с LAN/`available-from`, без
  возврата каталога common-ports. На устройство — только после явного «да».

## Вне рамок

- Правка `src/config/*.safe.rsc` агентом.
- `forward` и правило `Accept New Connections`.
- `chain-worms-detector` и DUMMY/passthrough (следующий проход).
- `chain-wwwssl-service` / WebFig 4443 (www-ssl сейчас disabled).
- Firewall на `chr` / `capxl`.
- Перепись staged SSH/Winbox/Telnet/RDP и существующих allow-list.
- Новые address-list и knock для DHCP/NTP.
- Возврат всего каталога common-ports.

## Затрагиваемые capabilities

- `firewall-input-services` — см. [`specs/firewall-input-services/spec.md`](specs/firewall-input-services/spec.md).

## Критерии приёмки

- [x] На `anna` нет jump и правил `chain-self-common-ports`.
  Проверка: `/ip firewall filter print where chain=chain-self-common-ports`
  и `jump-target=chain-self-common-ports` пусты.
  (soak `common=0`; tasks 2.2)
- [x] Есть jump в `chain-dhcp-server` и `chain-ntp-server` из `input`.
  Проверка: `print where jump-target=chain-dhcp-server or jump-target=chain-ntp-server`.
  (evidence + samples)
- [x] Подготовлена и выкатана цепочка для **TCP/443** Containers over
  reverse-proxy: `jump → accept (LAN) → return`, без разрыва чужой цепочкой;
  `https://*.anna.home` открывается с LAN.
  Проверка: [`evidence/reverse-proxy-20261124.md`](evidence/reverse-proxy-20261124.md);
  smoke tasks 7.2.
- [x] Правила каждой новой цепочки размещены **последовательно без разрыва
  чужой цепочкой**: схема `jump → …тело… → return`.
  Проверка: полный `/ip firewall filter print` (не `where`/`stats`) —
  позиции **132–140**; [`evidence/filter-layout-20261124.md`](evidence/filter-layout-20261124.md).
  Замечание verify: номера в `print stats where` (0/1/52…) **не** позиции списка.
- [x] DHCP lease на main/guest/docker/netinstall и NTP к anna с LAN
  проходят после снятия каталога. Проверка: soak counters + capxl bound/sync.
- [x] SSH :2223, Winbox LAN, DNS LAN, SMB, VPN, CAP, proxy 8888 не сломаны.
  Проверка: T0 smoke + soak VPN/OSPF/DNS peer; management не в hourly
  (остаточный пробел evidence — не регресс).
- [x] Проведены **бдительные и длительные** тесты смежников: ранний soak
  ~12.4 ч по решению оператора (короче 24 ч — явно).
  Проверка: `soak/TELEMETRY.md` + итог soak в proposal.
- [x] Нет новых `alist-fw-*` для DHCP/NTP. Проверка: design/tasks; на
  устройстве не добавляли.
- [x] Агент не менял `src/config/*.safe.rsc`. Проверка: `git status` по
  `src/config`.
- [x] `git diff --check` без замечаний (на отслеживаемых; change untracked).

### План стабильности смежников

**Длительность:** **24 часа** обычной эксплуатации с момента выката
(T0 = момент remove common-ports). При необходимости оператор может
удлинить до 48–72 ч; короче 24 ч — только явным решением.

**Схема контрольных точек**

```text
T0 (сразу)     — smoke: живы ли сервисы после снятия каталога
T+1 ч          — ранние renew / повторные сессии / рост counters
T+24 ч         — итог soak: renew, смежники, drop-лог за сутки
               → решение: /sdd-verify или удлинить / чинить
```

**Как снимать данные (на каждой точке)**

- **anna (сервер):** counters `chain-dhcp-server` / `chain-ntp-server` и jump;
  `#DROP UNKNOWN (INPUT)` за интервал (топ dst-port / in-interface; адреса
  клиентов в чат не выводить без нужды); DHCP lease active; VPN/CHR;
  CAP registration; OSPF neighbor
- **capxl (клиент смежников):** допускается read-only телеметрия — DHCP lease
  к anna, NTP sync к anna, DNS/резолв, доступность SSH/Winbox anna с LAN,
  состояние CAP к anna. capxl — типичный клиент многих сервисов anna; правки
  firewall на capxl этим изменением не делаем
- **Автономный сбор (2026-11-23 → 2026-11-24 22:23 MSK):** оператор разрешил
  почасовой read-only опрос anna+capxl без пошаговых подтверждений; только
  сбор и фиксация динамики в soak/TELEMETRY.md и приёмочных артефактах
  изменения; config не менять. Runner: `soak/run-hourly-until.sh`

#### Критерии стабильности (pass / fail)

| Область | Pass | Fail |
| --- | --- | --- |
| Каталог | common-ports = 0 на всех точках | Правила/jump каталога вернулись |
| DHCP | Accept counters растут к T+24; есть renew на сегментах с клиентами; нет жалоб «нет IP» | Нет renew при живых клиентах; accept=0 при активности LAN |
| NTP | Accept counters растут к T+24; LAN-клиент синхронизирован | Accept=0 при LAN-запросах; клиенты потеряли sync из‑за anna |
| DNS / SSH / Winbox / SMB / proxy | Рабочие сессии на T0 и T+24 | Нельзя установить нужный доступ с доверенного LAN |
| VPN / CAP / OSPF | Туннель/соседи/CAP в норме на T0 и T+24 | Падение смежника, коррелирующее с выкатом input |
| DROP UNKNOWN | WAN-шум к legacy-портам каталога допустим; **нет** устойчивого роста drop с LAN-bridge на порты нужных сервисов (53/67/68/123/2223/8291/8888/SMB/VPN) | Массовые `#DROP UNKNOWN` с LAN на эти порты или регресс сервиса + drop в логе |
| Jump NTP ≫ accept | Допустимо (WAN/чужие iface); accept LAN > 0 к T+24 | Jump растёт, accept LAN = 0 весь soak |
| reverse-proxy :443 | После выката цепочки 443: нет LAN-drop на :443; URL `*.anna.home` открываются | `#DROP UNKNOWN` SYN→anna:443 с LAN (как сейчас до фикса) |

**Итог soak:** все строки Pass на T+24 (или на удлинённом сроке) **и** закрыт
регресс 443 → можно `/sdd-verify`. Любой Fail → `/sdd-apply` или откат.

### Итог soak (ранний stop оператором, 2026-11-24 11:07 MSK)

Оператор остановил телеметрию до планового T+24 (22:23). Окно наблюдения
≈ **12.4 ч** (T0 ~22:45 23.11 → 11:07 24.11). Финальный sample
`20261124-110707.md`.

| Область | Вердикт | Факты |
| --- | --- | --- |
| Каталог | **Pass** | `common-ports=0` на всех 16+ тиках |
| DHCP | **Pass** | accept 5→**93**, jump 22→**323**; leases 13–15 (нормальная флуктуация); capxl `bound` весь soak |
| NTP | **Pass** | accept 6→**91**; raw jump ≈**12519** (не «убывающий» 749→519 — баг парсера тысяч); capxl `synchronized` весь soak |
| Jump NTP ≫ accept | **Pass** | Jump ≫ accept ожидаемо (шум вне list); LAN accept растёт |
| VPN / CAP / OSPF | **Pass** | `chr-tunnel=running`, OSPF neighbor=1 стабильно |
| DROP UNKNOWN (soak counter) | **условно** | `drop_log=0` каждый тик — слабый сигнал (буфер/паттерн); :443 закрыт после 7.2 |
| reverse-proxy :443 | **Pass (после 7.2)** | evidence + smoke; см. tasks 7.2 |
| DNS/SSH/Winbox/SMB | **не переснимались** в hourly | T0 smoke ок; регрессов в soak-метриках нет |

**Вывод:** ранний soak (~12.4 ч) по решению оператора достаточен для
DHCP/NTP/смежников. Выкат 443, раскладка 6.1, comments 8.2 закрыты
2026-11-24; evidence в `evidence/`. Follow-up SMB:445 / FTP:21 — вне
выката. Парсер soak: `get packets` (долг тысяч закрыт).

## Анализ потерянных сценариев (после снятия каталога)

Метод: живые `/ip service` + reverse-proxy + containers + input accepts vs
порты, которые раньше принимал common-ports. Устройство не менялось.

### Подтверждённый регресс

| Сценарий | Порт | Было в каталоге | Сейчас | Симптом |
| --- | --- | --- | --- | --- |
| Containers over reverse-proxy (SNI: victoria / wiren / sprut / metrics / netro `.anna.home`) | TCP **443** | accept «SSTP & HTTPS» | **было** без accept → DROP; **сейчас** `chain-reverse-proxy` (`src-address=192.168.90.0/24`) | Регресс закрыт выкатом 7.2 |
| Контейнеры сами | 9428/7575/… | не input-каталог | running; dstnat/port-rdr | Живы; путь `https://*.anna.home` = **443 SNI**, не прямой порт |

### Покрыто точечно (ожидаемо ок)

DHCP 67/68, NTP 123 (новые цепочки); DNS 53 (dns-amp); SSH 2223; Winbox 8291
+ staged; SNMP 161 (LAN services); HTTP 80 (self-fetch + LAN WEB); SMB
137–139 (allow-list); VPN 500/4500/1701; CAP 5246–47; neighbor 5678; OSPF;
proxy 8888 (правило есть; служба сейчас disabled).

### Риски / кандидаты (пока без массовых drop в логе)

| Сценарий | Порт | Заметка |
| --- | --- | --- |
| RouterOS SMB share на anna | TCP **445** | Служба smb слушает; filter только 137–139; в каталоге был 445. Новых drop :445 пока 0 — проверить доступ к шаре отдельно |
| FTP на роутере | TCP **21** | `/ip service` ftp **не** disabled; каталог принимал 21; теперь new → final drop. Если FTP не используют — ок |
| www-ssl / WebFig | 4443 | **disabled** — вне рамок |
| UPnP 1900/2828 | — | Слушает dynamic; в каталоге не было — не регресс снятия каталога |
| GRE | gre | Интерфейсов gre нет |
| Legacy mail/ldap/pptp/ovpn/… | каталог | Не сервисы anna — ожидаемый drop |

### Урок для приёмки

Smoke обязан включать **все** записи `/ip service` без `disabled` и
`/ip reverse-proxy`, не только dhcp/ntp/ssh. Порт из каталога нельзя
списывать в «мусор», пока живая служба на этом порту не сопоставлена.

## Именование comment vs смысл правила

Было: `Accept DHCP/NTP server` — ложный субъект. Канон и критика —
в `design.md`. На anna после 8.2: `DHCP clients to server` /
`NTP clients to server` / `jump dhcp-server` / `jump ntp-server`;
soak `collect-once.sh` читает `get packets` по новым comment.

## Follow-up вне выката 002 (после 7.3)

- SMB **445**: служба enabled; input accept только 137–139. Если шара нужна
  по TCP/445 — отдельная цепочка; иначе оставить как есть.
- FTP **21**: `/ip service` ftp enabled, `available-from` пуст; accept нет —
  new → final drop. Если не используют — `disable` service (предпочтительнее
  filter).

## Открытые вопросы

- Нет (comments 8.2 и 443 выкатаны 2026-11-24).
