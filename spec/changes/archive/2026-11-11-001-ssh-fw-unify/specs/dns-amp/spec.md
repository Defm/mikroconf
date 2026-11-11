# dns-amp: дельта

## ADDED Requirements

### Requirement: Drop TCP DNS с WAN на chr

На `chr` в `chain-dns-amp-attack` входящий TCP DNS с WAN отбрасывается.
Правило внесено вне процедуры выката SSH и принято в это изменение.

#### Scenario: WAN TCP/53

- WHEN пакет `tcp` с `dst-port=53` приходит на chr с
  `in-interface-list=list-FW-prevent-dns-requests-WAN`
- THEN срабатывает drop в `chain-dns-amp-attack`
- AND UDP-правила этой цепочки этим изменением не переписываются

## MODIFIED Requirements

Нет.

## REMOVED Requirements

Нет.
