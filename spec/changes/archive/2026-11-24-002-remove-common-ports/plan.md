---
name: Удаление common-ports
overview: Упразднить на anna каталог chain-self-common-ports; DHCP/NTP точечными jump-цепочками; закрыть регресс reverse-proxy TCP/443.
todos:
  - id: 1-1-iface-list
    content: 1.1 Создать list-router-input-services (4 bridge) на anna
    status: completed
  - id: 1-2-dhcp-chain
    content: 1.2 Добавить chain-dhcp-server + jump
    status: completed
  - id: 1-3-ntp-chain
    content: 1.3 Добавить chain-ntp-server + jump
    status: completed
  - id: 2-1-disable-common
    content: 2.1 Disable jump common-ports, наблюдение
    status: completed
  - id: 2-2-remove-common
    content: 2.2 Remove jump и chain-self-common-ports
    status: completed
  - id: 3-1-snapshot
    content: 3.1 Обновить anna.safe.rsc — отменено (агент не пишет safe.rsc)
    status: cancelled
  - id: 3-2-repo-check
    content: 3.1 check-repository.sh и git diff --check
    status: completed
  - id: 5-1-neighbor-smoke
    content: 5.1 T0 smoke смежников + baseline counters
    status: completed
  - id: 5-2-neighbor-t1h
    content: 5.2 T+1ч counters и DROP UNKNOWN
    status: completed
  - id: 5-3-neighbor-soak
    content: 5.3 Итог soak (ранний stop)
    status: completed
  - id: 9-verify-fix
    content: 9.x Evidence + sync после /sdd-verify fail
    status: completed
  - id: 7-1-spec-443
    content: 7.1 Spec chain-reverse-proxy TCP/443
    status: completed
  - id: 7-2-apply-443
    content: 7.2 Выкат chain-reverse-proxy на anna (после «да»)
    status: completed
  - id: 7-3-smb-ftp-risk
    content: 7.3 Проверка риска SMB:445 и FTP:21
    status: completed
  - id: 6-1-layout
    content: 6.1 Непрерывный jump→тело→return
    status: completed
  - id: 8-2-comments
    content: 8.2 Rename comments + парсер soak
    status: completed
isProject: false
---

# 002-remove-common-ports

Spec: [`spec/changes/002-remove-common-ports/`](./) — статус `archived`.

## Зачем

`chain-self-common-ports` (92 правила) — каталог IANA с голым accept; дыра поверх staged/LAN-политик. Упраздняем целиком.

## Что меняется на anna

1. `interface list` `list-router-input-services`: main / guest / docker / netinstall bridge (без WAN).
2. Jump-цепочки `chain-dhcp-server` (UDP 67,68) и `chain-ntp-server` (UDP 123) с `in-interface-list=list-router-input-services`.
3. Disable → remove jump и всей `chain-self-common-ports`.
4. Закрыть регресс Containers over reverse-proxy: `chain-reverse-proxy`
   (TCP/443, `src-address=192.168.90.0/24` = `available-from` службы).
5. Снимок `src/config/anna.safe.rsc` агент не обновляет.

Без новых address-list/knock. SSH/Winbox/DNS/VPN/SMB/CAP не трогаем (кроме
возможного follow-up SMB:445). Вне рамок: forward, worms, www-ssl,
chr/capxl, запись `*.safe.rsc`. Устройство для 443 — только после явного «да».

## Критерии

- Нет `chain-self-common-ports`
- Есть DHCP/NTP цепочки; lease и NTP живы
- Есть `chain-reverse-proxy`; `https://*.anna.home` с 192.168.90.0/24 открываются
- Management/DNS/SMB/VPN/CAP/proxy без регресса
- `git diff --check` ок; `*.safe.rsc` не менялись агентом

## Выкат

DHCP/NTP/remove common-ports, 443, раскладка 6.1, comments 8.2 на anna
выполнены. Evidence: `evidence/filter-layout-20261124.md`,
`evidence/reverse-proxy-20261124.md`. Следующее: `/sdd-verify`.
