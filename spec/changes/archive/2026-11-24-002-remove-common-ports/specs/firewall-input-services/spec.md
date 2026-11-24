# firewall-input-services: дельта

## ADDED Requirements

### Requirement: Нет каталога common-ports на anna

На `anna` во filter firewall нет цепочки-каталога `chain-self-common-ports`
и jump в неё из `input`.

#### Scenario: Каталог отсутствует

- WHEN проверяют filter на anna
- THEN правила с `chain=chain-self-common-ports` отсутствуют
- AND jump с `jump-target=chain-self-common-ports` отсутствует

### Requirement: DHCP через chain-dhcp-server

Входящий DHCP к серверу anna принимается только через jump-цепочку
`chain-dhcp-server`, ограниченную интерфейсами
`list-router-input-services`, без нового address-list и без knock.

#### Scenario: Jump DHCP

- WHEN пакет `input` `udp` с `dst-port` 67 или 68
- THEN срабатывает jump в `chain-dhcp-server`

#### Scenario: Accept на сервисных bridge

- WHEN пакет уже в `chain-dhcp-server` и `in-interface-list=list-router-input-services`
- THEN правило цепочки делает `accept`
- AND WAN не входит в `list-router-input-services`

### Requirement: NTP через chain-ntp-server

Входящий NTP к серверу anna принимается только через jump-цепочку
`chain-ntp-server`, ограниченную теми же интерфейсами
`list-router-input-services`, без нового address-list и без knock.

#### Scenario: Jump NTP

- WHEN пакет `input` `udp` с `dst-port=123`
- THEN срабатывает jump в `chain-ntp-server`

#### Scenario: Accept на сервисных bridge

- WHEN пакет уже в `chain-ntp-server` и `in-interface-list=list-router-input-services`
- THEN правило цепочки делает `accept`

### Requirement: Состав list-router-input-services

`list-router-input-services` содержит ровно bridge с dhcp-server anna:
`main-infrastructure-br`, `guest-infrastructure-br`,
`docker-infrastructure-br`, `adm-netinstall-br`.

#### Scenario: Члены списка

- WHEN смотрят members `list-router-input-services`
- THEN в списке эти четыре bridge
- AND `wan A` в списке отсутствует

### Requirement: Comment accept отражает клиентов к сервису

Comment у `action=accept` во входящих jump-цепочках сервисов описывает
приём **обращений клиентов к сервису** на роутере, а не «Accept \<server\>».
Имя `chain-<сервис>-<роль>` может называть роль сервиса; comment не
подменяет субъект.

#### Scenario: Новые цепочки без ложного субъекта

- WHEN добавляют accept в новую jump-цепочку сервиса (например
  `chain-reverse-proxy`)
- THEN comment в духе `clients to <service>` / `<service> clients`, не
  `Accept <service> server`
- AND на anna для DHCP/NTP: `DHCP clients to server` /
  `NTP clients to server` (после rename 8.2)

### Requirement: Reverse-proxy TCP/443 для контейнерных UI

Входящий HTTPS к anna для Containers over reverse-proxy принимается только
через отдельную jump-цепочку (канон имени: `chain-reverse-proxy`), с
`src-address` не шире `/ip service reverse-proxy available-from`
(сейчас `192.168.90.0/24`), без возврата каталога common-ports.

#### Scenario: Jump и accept 443

- WHEN пакет `input` `tcp` с `dst-port=443` и `src-address` из
  `available-from` службы reverse-proxy
- THEN срабатывает jump в `chain-reverse-proxy`
- AND правило цепочки делает `accept`
- AND источник вне `available-from` не получает accept 443 из этой цепочки

#### Scenario: UI контейнеров по SNI

- WHEN клиент из `192.168.90.0/24` открывает
  `https://victoria.anna.home`, `https://netro.anna.home`,
  `https://metrics.anna.home`, `https://wiren.anna.home` или
  `https://sprut.anna.home`
- THEN соединение не отбрасывается `#DROP UNKNOWN (INPUT)` на :443
- AND reverse-proxy может отдать бэкенд

### Requirement: Непрерывный блок правил одной цепочки

Правила одной custom-цепочки в `/ip firewall filter` размещаются
последовательно, без разрыва правилами другой цепочки. Канон:
`jump` (из caller) → тело цепочки → `return` (явный или конец цепочки).
Непрерывность смотрят по полному `print` (позиции списка). Колонка `#` в
`print where` / `print stats` может не совпадать с этим порядком — её не
использовать как доказательство разрыва.

#### Scenario: Блок DHCP без чужих правил внутри

- WHEN смотрят полный `print` filter на anna
- THEN все правила с `chain=chain-dhcp-server` идут подряд одним блоком
- AND между ними нет правил с другим `chain=`
- AND из `input` есть jump в эту цепочку, тело завершается return/концом

#### Scenario: Блок NTP без чужих правил внутри

- WHEN смотрят полный `print` filter на anna
- THEN все правила с `chain=chain-ntp-server` идут подряд одним блоком
- AND между ними нет правил с другим `chain=`
- AND из `input` есть jump в эту цепочку, тело завершается return/концом

### Requirement: Бдительные и длительные тесты смежников после снятия каталога

После удаления `chain-self-common-ports` обязательны бдительные и длительные
тесты смежников: разовый smoke и повторная проверка после периода обычной
эксплуатации, плюс просмотр drop-лога. Нужные сервисы живы; трафик
упразднённого каталога либо покрыт точечными цепочками, либо ожидаемо
отбрасывается.

#### Scenario: Smoke сразу после выката

- WHEN завершён выкат без common-ports
- THEN проверяют DHCP, NTP, DNS, SSH, Winbox, SMB, proxy, VPN, CAP/OSPF
  по чеклисту изменения

#### Scenario: Длительное наблюдение

- WHEN прошли контрольные точки T+1 ч и T+24 ч после выката (или удлинённый
  срок по решению оператора)
- THEN повторно проходят чеклист смежников и критерии pass/fail из proposal
  (lease renew, рост counters DHCP/NTP, доступ смежников)
- AND просматривают `#DROP UNKNOWN (INPUT)` за весь период на массовые drop
  нужных LAN-сервисов
