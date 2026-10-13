# Выпуск RouterOS-скриптов

## Подготовка

1. Измените файл в `src/scripts`.
2. Проверьте отсутствие секретов и device-specific literals.
3. Оцените совместимость с inventory и package dependencies.
4. Выполните `./tools/check-repository.sh`.
5. Подготовьте backup, критерии успеха и точный rollback.

## Публикация

Публикация идёт в `Defm/mikroconf` / `master/src/scripts`. Первое применение на
устройствах — по `docs/cutover-plan.md`:

1. опубликовать `mikroconf` с актуальным `src/scripts` на `master`;
2. на host `/REPO/raw` держать clone на `_autobranch`; Docker gitwatch
   смотрит этот каталог и пушит в `_autobranch` (как легаси);
3. переключить одно canary-устройство (`doFreshTheScripts`);
4. проверить download, размер, source, dump в `REPO/raw/src/scripts/` и
   автокоммит;
5. расширять по одному классу устройств;
6. сохранить возможность возврата к `mikrobackups` / `master/scripts` и
   dump `REPO/raw/scripts/`.

Dump/gitwatch не публикует release: устройства читают только `master`.
Содержимое `_autobranch` попадает в release только после review и merge.

Из-за ограничений RouterOS `fetch output=user` отдельно проверяйте крупные скрипты; загрузка не должна молча обрезать source.

## После выпуска

Проверьте журналы, отсутствие повторных jobs, ожидаемое расписание и функциональный результат. При расхождении остановите rollout и верните предыдущий source/path. Выпуск не выполняется автоматически из локального репозитория.
