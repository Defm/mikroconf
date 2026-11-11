# 001-ssh-fw-unify: единая SSH-защита anna и chr

Статус: in-progress

## Зачем

На `anna` и `chr` SSH защищён одной идеей staged-ban, но разными правилами:
разные jump, таймауты, листы исключения, WAN-drop только на `anna`, бан
SSH без порта режет весь input. Нужна одна custom chain, чтобы не отрезать
Winbox правилами SSH, не плодить device-custom и не сломать knock/backup.

## Что меняется

- Одинаковая `chain-ssh-staged-control` на `anna` и `chr`.
- Jump только `tcp` `22,2223` (без `5022`).
- Внутри цепочки: accept `alist-fw-ssh-allow`, drop `alist-fw-ssh-ban`,
  стадии 5 с / 40 с / 3 мин / бан 1w3d без `dst-port`, финальный accept
  неизбранных (решение оператора: knock живёт).
- Снаружи цепочки снимаются SSH-filter: WAN-drop SSH на `anna`, input/forward
  drop `alist-fw-ssh-ban`, accept SSH в `chain-self-common-ports` (tcp и udp).
- `$globalApplyKnock` пишет `alist-fw-ssh-allow`. На `anna` LAN /24 в этом
  листе уже есть. На `chr` статику с `alist-fw-knockknock` переносят.
- `/ip ssh set password-authentication=yes` на `anna`.
- Скрипт — отдельный коммит, merge в `master`, затем Fresh+env: chr, anna,
  capxl.

## Вне рамок

- Перепись цепочки Winbox.
- Firewall SSH на `capxl`.
- Снятие `alist-fw-ssh-ban` из knock.
- Правка port-knock портов на chr (`3006` vs `30004/30005/30006`).
- Device-custom без нового согласия.
- Режим «accept только allow-list» (отклонён: ломает первый SSH knock).

## Затрагиваемые capabilities

- `ssh-firewall` — см. [`specs/ssh-firewall/spec.md`](specs/ssh-firewall/spec.md).

## Критерии приёмки

- [ ] На `anna` и `chr` jump SSH: `input`, `tcp`, `dst-port=22,2223`.
  Проверка: `/ip firewall filter print where jump-target=chain-ssh-staged-control`.
- [ ] Внутри цепочки порядок: accept allow-list, drop ssh-ban, стадии без
  `dst-port`, финальный accept. Проверка: `print` цепочки на обоих.
- [ ] Нет SSH-accept в `chain-self-common-ports`. Проверка: `print where
  chain=chain-self-common-ports comment~"SSH"`.
- [ ] Нет input/forward drop `alist-fw-ssh-ban` вне SSH-цепочки и нет
  WAN-drop SSH на `anna`. Проверка: `print where src-address-list=alist-fw-ssh-ban`
  или `comment~"SSH"`.
- [ ] Winbox-правила не изменены этим выкатом. Проверка: diff снимка /
  `print` Winbox jump и lan/wan accept.
- [ ] LAN SSH на `anna` и SSH с anna на chr:2223 проходят. Проверка: новый
  коннект на 2223; Winbox LAN на `anna`.
- [ ] `$globalApplyKnock` пишет `alist-fw-ssh-allow`. Проверка: исходник
  `doEnvironmentSetup` и вызов knock/backup с anna.
- [ ] `git diff --check` без замечаний.

## Открытые вопросы

- Нет.
