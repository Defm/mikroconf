# ssh-firewall: дельта

## ADDED Requirements

### Requirement: Единая SSH-цепочка на anna и chr

SSH-filter input для службы роутера живут только в
`chain-ssh-staged-control`. Набор правил одинаков на `anna` и `chr`.

#### Scenario: Вход в цепочку

- WHEN пакет `input` `tcp` с `dst-port` 22 или 2223
- THEN срабатывает jump в `chain-ssh-staged-control`
- AND порт 5022 в jump отсутствует

#### Scenario: Allow-list

- WHEN источник в `alist-fw-ssh-allow`
- THEN первое правило цепочки его `accept`
- AND стадии не применяются

#### Scenario: Бан внутри цепочки

- WHEN источник в `alist-fw-ssh-ban` и пакет уже в SSH-цепочке
- THEN цепочка его `drop`
- AND правила Winbox этим drop не затрагиваются

#### Scenario: Неизбранный до бана

- WHEN источник не в allow-list и не в ssh-ban
- THEN пакет проходит стадии 5 с / 40 с / 3 мин / бан 1w3d без `dst-port` на
  стадиях
- AND последнее правило цепочки его `accept`

#### Scenario: Нет SSH-filter снаружи цепочки

- WHEN проверяют `chain-self-common-ports`, WAN-services и input/forward ban
- THEN SSH-accept tcp/udp в common-ports отсутствует
- AND input/forward drop по `alist-fw-ssh-ban` вне SSH-цепочки отсутствует
- AND на anna нет WAN-drop SSH

### Requirement: Knock пишет ssh-allow

`$globalApplyKnock` добавляет адрес в `alist-fw-ssh-allow` на 5 мин и чистит
ssh-stage1/2/3. Лист `alist-fw-ssh-ban` не трогает.

#### Scenario: Имя листа

- WHEN вызывают `$globalApplyKnock`
- THEN add/remove идут в `alist-fw-ssh-allow`
- AND не в `alist-fw-knockknock`

### Requirement: Пароль SSH на anna

На `anna` включён `password-authentication` у `/ip ssh`. Это не filter.

#### Scenario: Настройка

- WHEN читают `/ip ssh` на anna
- THEN `password-authentication=yes`

## MODIFIED Requirements

Нет. Capability новая.

## REMOVED Requirements

Нет.
