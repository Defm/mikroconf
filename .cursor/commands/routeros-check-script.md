---
description: Офлайн-проверка RouterOS-скрипта проекта по стилю, синтаксису и версиям
---

Проверь указанный пользователем файл `src/scripts/*.rsc.txt` без запуска на
устройстве.

1. Прочитай `routeros-scripting`, раздел 4 `doc/style-canon.md` и версии
   RouterOS из `doc/devices/inventory.md`.
2. Проверь заголовок и footer, `:onerror errorDescr`, camelCase, отсутствие
   завершающих `;`, selectors, globals, permissions и идемпотентность.
3. Для командных путей и свойств используй `routeros_explain_command`.
4. Совместимость команд проверь через `routeros_command_version_check` для
   версий из inventory.
5. Раздели результат на ошибки, риски и неподтверждённые места. Для каждой
   находки укажи строку файла и краткое исправление.

Это только локальный review. Не используй `mikrotik-readonly`, SSH, SFTP, SCP,
RouterOS MCP write-tools, `/console/inspect` реального устройства и не запускай
скрипт. Не изменяй файл, если пользователь просил только проверку.
