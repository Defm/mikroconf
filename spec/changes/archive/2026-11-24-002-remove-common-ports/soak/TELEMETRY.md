# Soak telemetry 002-remove-common-ports

Плановый интервал: до **2026-11-24 22:23 Europe/Moscow**.
**Остановлен оператором 2026-11-24 ~11:07 MSK** (раньше полного T+24).
Только чтение anna+capxl. Без правок config.

Автономный runner: `soak/run-hourly-until.sh` (stopped-by-operator).
Подтверждения на тики не требовались (решение оператора 2026-11-23).

**Артефакт парсера:** в таблице `ntp A/J` поле jump после ~1000 пакетов
ломается (RouterOS `12 519` → awk `$NF` = `519`). Реальный NTP jump на
финале ≈ **12519** (см. raw stats в sample). DHCP jump/accept в таблице
достоверны (<1000). Анализ — в `proposal.md`.

| TS (MSK) | verdict | common | dhcp A/J | ntp A/J | leases | ospf | tunnel | drop_log | capxl dhcp | capxl ntp | note | sample |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-11-23T22:44:10+0300 | pass | 0 | / | / | 14 | 1 | running | 0 | bound | synchronized |  | [20261123-224410](samples/20261123-224410.md) |
| 2026-11-23T22:44:44+0300 | pass | 0 | 5/22 | 6/739 | 14 | 1 | running | 0 | bound | synchronized |  | [20261123-224444](samples/20261123-224444.md) |
| 2026-11-23T22:45:03+0300 | pass | 0 | 5/22 | 6/745 | 14 | 1 | running | 0 | bound | synchronized |  | [20261123-224503](samples/20261123-224503.md) |
| 2026-11-23T22:45:24+0300 | pass | 0 | 5/22 | 6/749 | 14 | 1 | running | 0 | bound | synchronized |  | [20261123-224524](samples/20261123-224524.md) |
| 2026-11-23T23:45:27+0300 | pass | 0 | 11/45 | 13/719 | 14 | 1 | running | 0 | bound | synchronized |  | [20261123-234527](samples/20261123-234527.md) |
| 2026-11-24T00:45:33+0300 | pass | 0 | 20/76 | 20/665 | 14 | 1 | running | 0 | bound | synchronized |  | [20261124-004533](samples/20261124-004533.md) |
| 2026-11-24T01:45:37+0300 | pass | 0 | 28/101 | 27/607 | 14 | 1 | running | 0 | bound | synchronized |  | [20261124-014537](samples/20261124-014537.md) |
| 2026-11-24T02:45:43+0300 | pass | 0 | 34/123 | 34/563 | 14 | 1 | running | 0 | bound | synchronized |  | [20261124-024543](samples/20261124-024543.md) |
| 2026-11-24T03:45:47+0300 | pass | 0 | 40/148 | 41/508 | 14 | 1 | running | 0 | bound | synchronized |  | [20261124-034547](samples/20261124-034547.md) |
| 2026-11-24T04:45:51+0300 | pass | 0 | 52/176 | 47/462 | 14 | 1 | running | 0 | bound | synchronized |  | [20261124-044551](samples/20261124-044551.md) |
| 2026-11-24T05:45:57+0300 | pass | 0 | 56/197 | 55/421 | 13 | 1 | running | 0 | bound | synchronized |  | [20261124-054557](samples/20261124-054557.md) |
| 2026-11-24T06:46:01+0300 | pass | 0 | 62/219 | 61/338 | 13 | 1 | running | 0 | bound | synchronized |  | [20261124-064601](samples/20261124-064601.md) |
| 2026-11-24T07:46:07+0300 | pass | 0 | 70/244 | 69/282 | 13 | 1 | running | 0 | bound | synchronized |  | [20261124-074607](samples/20261124-074607.md) |
| 2026-11-24T08:46:11+0300 | pass | 0 | 74/270 | 75/242 | 13 | 1 | running | 0 | bound | synchronized |  | [20261124-084611](samples/20261124-084611.md) |
| 2026-11-24T09:46:16+0300 | pass | 0 | 83/296 | 82/229 | 15 | 1 | running | 0 | bound | synchronized |  | [20261124-094616](samples/20261124-094616.md) |
| 2026-11-24T10:46:20+0300 | pass | 0 | 91/321 | 89/189 | 14 | 1 | running | 0 | bound | synchronized |  | [20261124-104620](samples/20261124-104620.md) |
| 2026-11-24T11:07:07+0300 | pass | 0 | 93/323 | 91/12519* | 14 | 1 | running | 0 | bound | synchronized | stop; *ntp J из raw | [20261124-110707](samples/20261124-110707.md) |

## Итог раннего stop (~12.4 ч)

Все hourly verdict = **pass**. Runner остановлен; сводка pass/fail —
раздел «Итог soak (ранний stop)» в `proposal.md`.

Пост-stop sample (после 6.1/8.2, парсер `get packets`):

| TS (MSK) | verdict | common | dhcp A/J | ntp A/J | leases | ospf | tunnel | drop_log | capxl dhcp | capxl ntp | note | sample |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-11-24T11:19:17+0300 | pass | 0 | 96/326 | 93/12715 | 14 | 1 | running | 0 | bound | synchronized | post-layout | [20261124-111917](samples/20261124-111917.md) |
