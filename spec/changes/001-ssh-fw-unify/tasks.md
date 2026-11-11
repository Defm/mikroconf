# 001-ssh-fw-unify: шаги

## 1. Канон скрипта и документации

- [x] 1.1 В `src/scripts/doEnvironmentSetup.rsc.txt` `$globalApplyKnock`
  пишет `alist-fw-ssh-allow` (remove/add и комментарий). Очистка stage1/2/3
  без снятия ssh-ban.
  Проверка: поиск `alist-fw-knockknock` в этом скрипте пуст для add/remove
  knock; `alist-fw-ssh-allow` есть.
- [x] 1.2 Обновить имя листа в `doc/operations/backup-pipeline.md` и
  `doc/style-canon.md`.
  Проверка: в этих файлах нет устаревшего SSH-исключения `alist-fw-knockknock`
  как цели knock.
- [x] 1.3 Коммит только скрипта и этих docs, сообщение Conventional Commits
  по-русски.
  Проверка: `git show --stat` не содержит live inventory и `src/config/*.safe.rsc`.

## 2. Firewall chr

- [ ] 2.1 Создать `alist-fw-ssh-allow`, перенести статику с
  `alist-fw-knockknock`, временно dual-list на accept/stage1.
  Проверка: address-list print без вывода адресов в чат; оба имени листа есть.
  Требует подтверждения: запись на RouterOS-устройстве chr.
- [ ] 2.2 Собрать цепочку: jump `22,2223`; внутри accept allow, drop ban,
  стадии 5 с / 40 с / 3 мин без dst-port, финальный accept. Снять input/forward
  ssh-ban, SSH из common-ports, `5022` из jump и log.
  Проверка: `print` jump и цепочки; пустой find SSH в common-ports; новый SSH
  :2223; Winbox не отвалился.
  Требует подтверждения: запись на RouterOS-устройстве chr.

## 3. Firewall anna

- [ ] 3.1 Та же цепочка, что на chr. Снять WAN-drop SSH. Не дублировать
  LAN /24 в allow-list. `/ip ssh set password-authentication=yes`.
  Проверка: тот же `print`, что в 2.2; LAN SSH :2223 новым коннектом; LAN
  Winbox; WAN-drop SSH отсутствует.
  Требует подтверждения: запись на RouterOS-устройстве anna.

## 4. Выкат скрипта

- [ ] 4.1 Push `_autobranch` и merge в `master` (doFresh читает master).
  Проверка: `master` содержит коммит knock-листа.
  Требует подтверждения: push и merge.
- [ ] 4.2 `doFreshTheScripts` и `doEnvironmentSetup` на chr, затем anna,
  затем capxl.
  Проверка: SUCCESS скриптов; на chr knock пишет `alist-fw-ssh-allow`.
  Требует подтверждения: `/system script run` на устройствах.
- [ ] 4.3 Снять dual-list на chr: SSH-исключение только
  `alist-fw-ssh-allow`.
  Проверка: stage1/accept не ссылаются на `alist-fw-knockknock`.
  Требует подтверждения: запись на chr.

## 5. Проверка

- [ ] 5.1 Knock и `doBackup` с anna; SSH :2223 и Winbox LAN; снимки
  `src/config` после backup.
  Проверка: SUCCESS backup; в цепочке снимка нет SSH в common-ports.
  Требует подтверждения: `/system script run doBackup`.
- [ ] 5.2 `git diff --check` без замечаний.
  Проверка: команда в корне репозитория.
