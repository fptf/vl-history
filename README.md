# Улицы Владивостока: тематическая систематика названий — выгрузка

Дата: 13 ноября 2026 г.

## Состав

| Папка / файл | Что внутри |
|---|---|
| summary.md | Краткий итог исследования (копия документа «Топонимика улиц Владивостока: итоги исследования») |
| <private-workdir>/dialog.md | Расшифровка диалога |
| 02_data/streets_classification.csv | 820 улиц из списка ginfo: тип, группа, тематика, подтема, уверенность, примечание (UTF-8, разделитель «;») |
| 02_data/vladivostok_streets.xlsx | То же + лист статистики с формулами |
| 02_data/streets_map.geojson | 821 линия улиц (OSM) с годом названия и классификацией; поле in_ginfo_list=false у ~140 улиц, размеченных дополнительно |
| 02_data/stats_by_theme.csv | Число улиц по группам и тематикам |
| 02_data/timeline_by_decade.csv | Число линий по десятилетиям нынешнего названия и группам |
| 02_data/vvmap_streets_years.csv, vvmap_capes.geojson | Исходные данные проекта vvmap (годы и источники, мысы) |
| 02_data/ginfo_streets_raw.txt | Исходный список улиц с ginfo.ru |
| 03_sources/sources.md | Источники и условия использования |
| 04_prototype/vladivostok-streets-map.html | Рабочий прототип карты: один файл, открыть в браузере (работает офлайн, шрифт подгружается из Google Fonts при наличии сети) |
| 05_code/ | Скрипты: build.sh (сборка одной командой), classify.py (классификация), build.py (xlsx), prep.py (сборка данных карты), assemble.py (подстановка данных в шаблон), map_template.html.tpl (шаблон карты без данных — не открывать в браузере), requirements.txt |

## Как пересобрать карту

Из корня репозитория — одна команда:

```
bash 05_code/build.sh
```

Нужны python3 и openpyxl (`pip install -r 05_code/requirements.txt`). Внутри: classify.py строит rows.json из 02_data/ginfo_streets_raw.txt; build.py пишет 02_data/vladivostok_streets.xlsx; prep.py собирает 05_code/data.json из 02_data/streets_map.geojson и 02_data/vvmap_capes.geojson; затем data.json подставляется в map_template.html.tpl вместо `__DATA__`, результат сохраняется как 04_prototype/vladivostok-streets-map.html. Промежуточные rows.json и data.json в git не входят (в .gitignore).

Открывать в браузере нужно только 04_prototype/vladivostok-streets-map.html, предварительно распаковав архив. В окне предпросмотра (Quick Look на Mac, панель просмотра Windows, мессенджеры, почта) JavaScript не выполняется, и карта будет пустой.

## Важные оговорки

- Год в данных — год нынешнего названия или первого упоминания, не год появления улицы. Пик 1920-х во многом даёт справочник 1924 г.
- Классификация авторская; 85 названий помечены «нужна проверка».
- Геометрия — © участники OpenStreetMap (ODbL). У репозитория vvmap нет явной лицензии: перед публикацией стоит уточнить условия у автора.
