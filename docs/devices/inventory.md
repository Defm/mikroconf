# Инвентарь активных устройств

Источник сведений — последние доступные exports. Значения секретов, серийные номера и адреса управления намеренно не приводятся.

| Устройство | Модель | RouterOS | Зафиксированные активные packages |
|---|---|---:|---|
| `anna` | RB5009UPr+S+ | 7.24.1 | wireless, netinstall, rose-storage, iot, container, routeros |
| `capxl` | RBcAPGi-5acD2nD | 7.24.2 | wireless, routeros |
| `capax` | cAPGi-5HaxD2HaxD | 7.23.1 | zerotier, wifi-qcom, container, routeros |
| `atl` | ATLGM | 7.23.1 | gps, routeros |
| `CHR` | Cloud Hosted Router | 7.24.2 | routeros, container |
| `mikrouter` | RB962UiGS-5HacT2HnT | 7.15.3 | export не содержит надёжного итогового списка packages |

## Замечания

- `mikrouter` основан на более старом export, поэтому перед выпуском следует отдельно проверить доступные команды RouterOS 7.15.3.
- Целевой канон использует `:onerror` (есть в RouterOS с 7.13). На `anna`/`capxl`/`capax`/`atl`/`CHR` (7.23–7.24) это подтверждено по парку 7.2x. На `mikrouter` (7.15.3) команда должна быть доступна, но перед cutover её нужно проверить на устройстве: если интерпретатор её не принимает, `mikrouter` исключается из выката до обновления прошивки.
- Скрипты, зависящие от `wireless`, `wifi-qcom`, `gps`, `container`, `iot` или `zerotier`, нельзя распространять на весь парк без capability-check.
- Неактивные и исторические exports не являются основанием для deploy.
- Inventory не содержит credentials; локальные параметры доступа должны храниться вне Git.
