# План будущего cutover

Этот документ не разрешает применение. Cutover выполняется отдельной задачей
после выбора GitHub URL, raw retention и проверки read-only диагностики.

## Предусловия

1. Новый remote создан, `master` защищён от прямого push.
2. Secret scan и локальные проверки проходят на опубликованном commit.
3. Все необходимые `$SECRET` keys настроены на canary.
4. Доступны старый и новый URL; старый release path не удалён.
5. Есть проверенный text restore-export и binary backup canary.
6. Скрипты больше 4096 байт проверены отдельно: текущий `output=user` нельзя
   считать доказанно надёжным для них.

## Изменения

- `doFreshTheScripts`: заменить repository URL и `master/scripts/` на
  `master/src/scripts/`;
- `doDumpTheScripts`: заменить целевой tracked path на `src/scripts/`;
- не менять `UpdateList` в том же change;
- не исправлять прочие behavioral findings попутно.

## Порядок

1. Создать immutable backup и зафиксировать pre-state canary.
2. Вручную обновить только `doFreshTheScripts` на canary.
3. Выполнить один refresh и сравнить source каждого allowlisted script.
4. Проверить startup, connectivity, routing, DNS, VPN и logs.
5. Выдержать согласованный период наблюдения.
6. Повторять по одному устройству; CHR и основной router — последними.

## Остановка и откат

Остановиться при fetch error, усечённом source, неожиданном script diff,
потере management/VPN/DNS или новых errors в logs. Откат — восстановить старый
`doFreshTheScripts` и source изменённых скриптов из сохранённого text export.
Binary restore применяется только как отдельная аварийная процедура.
