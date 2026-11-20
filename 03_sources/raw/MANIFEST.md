# Манифест сырых данных (sha256)

Дата: 13.11.2026. Сюда входят сырые выгрузки и первоисточники проекта; производные файлы (классификация, карта, xlsx, HTML) — не сырьё, их происхождение описано в [../provenance.md](../provenance.md). Файлы лежат на своих местах, манифест ничего не перемещает.

Проверка из корня репозитория: `sha256sum -c 03_sources/raw/SHA256SUMS`

| Файл | Первоисточник | Дата | sha256 | Размер, байт |
|---|---|---|---|---|
| `02_data/ginfo_streets_raw.txt` | vladivostok.ginfo.ru/ulicy/; сырой список улиц: 820 строк «тип\|название» после чистки из 845 позиций | 13.11.2026 | `775622c9f52ef452…` | 21 194 |
| `02_data/vvmap_streets_years.csv` | github.com/skirienko/vvmap; сырая выгрузка vvmap: годы названий (1212 записей) | 13.11.2026 | `082b5ca68beae912…` | 147 008 |
| `02_data/vvmap_capes.geojson` | github.com/skirienko/vvmap; сырая выгрузка vvmap: мысы (точки) | 13.11.2026 | `3805b805f9004c5e…` | 22 032 |
| `02_data/ФКР_дома_с_координатами.csv` | fkr25.ru («Электронная база данных.xls») + геокодер Фарпоста; собран Вёрстом; 11 639 строк; первоисточник и метод — 03_sources/raw/fkr25/PROVENANCE_verst_answer.md | 13.11.2026 | `2353133b02ca50d2…` | 4 170 195 |
| `06_research/findings.jsonl` | веб-исследование V2 (URL в каждом вердикте «опознан»); сырые вердикты: 52 опознан (40 высокая + 12 предположительно), 33 не найдено | 13.11.2026 | `6e226761ad638a22…` | 60 168 |
| `03_sources/raw/fkr25/PROVENANCE_verst_answer.md` | агент «Вёрст» + протокол приёмки Болта; полный протокол происхождения ФКР-выгрузки | 13.11.2026 | `a7287cb7b55eb73a…` | 9 722 |
| `03_sources/raw/fkr25/provenance/fkr_fkr25.xls` | https://fkr25.ru/files/2014-2088/Электронная база данных.xls; первоисточник: приложение к Постановлению Администрации ПК от 31.12.2013 № 513-па; копия обезличена 17.11.2026 (ФИО в метаданных → пробелы, ячейки не тронуты), sha256 оригинала `9a3d517964094e62…` — см. provenance.md | 13.11.2026 (Last-Modified сервера 30.04.2026) | `bb272588608f4605…` | 4 276 736 |
| `03_sources/raw/fkr25/provenance/fkr_geocode.py` | агент «Вёрст»; скрипт геокодирования, пасс 1 | 13.11.2026 | `2ae800fed9c8fb36…` | 7 830 |
| `03_sources/raw/fkr25/provenance/fkr_geocode2.py` | агент «Вёрст»; скрипт до-геокодирования отказов | 13.11.2026 | `8bd6def0e47f52dc…` | 9 447 |
| `03_sources/raw/fkr25/provenance/fkr_assemble.py` | агент «Вёрст»; сборка ФКР_дома_с_координатами.csv | 13.11.2026 | `a7af2d909c5d29c3…` | 6 912 |
| `03_sources/raw/fkr25/provenance/fkr_geo.jsonl` | <internal-geocoder-host>/<internal-geocoder-endpoint>; сырые ответы геокодера, пасс 1 (10 643 принятых, все precision=exact) | 13.11.2026 | `67910902f758b1df…` | 5 335 056 |
| `03_sources/raw/fkr25/provenance/fkr_geo2.jsonl` | <internal-geocoder-host>/<internal-geocoder-endpoint>; сырые ответы геокодера, до-геокодирование | 13.11.2026 | `c3d70632664d981c…` | 63 603 |
| `02_data/osm_coastline_raw.json` | OpenStreetMap (Overpass): береговая линия natural=coastline, bbox 42.60–43.60 / 131.30–132.60, для слоя воды (V15); ODbL | 14.11.2026 | `a20213bd4467ec0b…` | 3 058 513 |
| `02_data/osm_buildings_vl.json` | OpenStreetMap через Geofabrik (far-eastern-fed-district, выгрузка 13.11.2026): контуры зданий Владивостокского ГО, 05_code/osm_buildings_extract.py; ODbL | 15.11.2026 | `976e4c4dfe2e85be…` | 17 634 912 |
| `02_data/osm_places.json` | OpenStreetMap (Overpass): бухты, острова, пролив (центр объекта) и 4 реки (waterway=river, геометрия 25 way) для слоя «бухты, реки, мысы», только объекты из 06_research/places.json; 05_code/osm_places_fetch.py; ODbL | 21.11.2026 (снимок базы 20.11.2026) | `6d58b188e67dbcfa…` | 41 401 |

Полные хэши — в блоке ниже и в `SHA256SUMS` (машинный формат sha256sum).

```
775622c9f52ef452fb01ada568042a818b7d1fa762c3ac4cf39cab1663ced347  02_data/ginfo_streets_raw.txt
082b5ca68beae912333827f6eecc17c0725e9c26954f94fc3f519620275173d3  02_data/vvmap_streets_years.csv
3805b805f9004c5e05f4bc2abb2d3ae5488bcb5c4dacd62b1abeb00f4f88a4fe  02_data/vvmap_capes.geojson
2353133b02ca50d23052f3ca2d41ee8fa18b0fb66572c3e1f841da42ba7d30d6  02_data/ФКР_дома_с_координатами.csv
6e226761ad638a223c7453037a541591484dd757aeb5211128ea7f755e697052  06_research/findings.jsonl
a7287cb7b55eb73ac130563edd43360a67e20a5182c320b665c9705f93b6b072  03_sources/raw/fkr25/PROVENANCE_verst_answer.md
bb272588608f46055d58e9aea0d6bb76f1f2896c4ed365840195522b1a3594a3  03_sources/raw/fkr25/provenance/fkr_fkr25.xls
2ae800fed9c8fb36987bd2feb77b9c13ab9422920b17a8a754eebf591c6f30ca  03_sources/raw/fkr25/provenance/fkr_geocode.py
8bd6def0e47f52dc64c0f0636cc615c84924f6f4908a022c85882e7242413bb1  03_sources/raw/fkr25/provenance/fkr_geocode2.py
a7af2d909c5d29c36888532f7533666076427b2178ad5b7509498ea89c71a61a  03_sources/raw/fkr25/provenance/fkr_assemble.py
67910902f758b1df2dfcabae373acd0a9407150350f5ff5e23b5ab800873cdd9  03_sources/raw/fkr25/provenance/fkr_geo.jsonl
c3d70632664d981cee23b3248ac38012e8b7830cc73bad0f1ffb31096f26302b  03_sources/raw/fkr25/provenance/fkr_geo2.jsonl
a20213bd4467ec0be35637f3581b3f00565bf173010b9590a53b89b61d19bd1c  02_data/osm_coastline_raw.json
976e4c4dfe2e85beb60ba00b40b342134e14103ad0b6c158537e14da3b499cc5  02_data/osm_buildings_vl.json
6d58b188e67dbcfa589c42150dca81f95cbdae9ff8635c0915679e8b31369186  02_data/osm_places.json
```

## Чего в манифесте нет (честно)

- Сырых выгрузок страниц исследования V2 (`06_research/_*.html`/`_*.txt`) не существует: V2 сохранил только отчёт и `findings.jsonl` с URL источников, поэтому хэшировать нечего. Проверяемость — по URL в каждом вердикте.
- Классификация (`streets_classification.csv`), xlsx, `streets_map.geojson`, статистики и HTML — производные файлы, не сырые выгрузки; их происхождение — в provenance.md.

## Контрольная сумма манифеста

sha256 этого файла (посчитан по содержимому БЕЗ следующей строки):
`1ca4d62f2095f984ffeb11ca92a51f526bd789ecad43a0ee8f8390621941d405`

- `02_data/osm_coastline_raw.json` — сырой ответ Overpass (natural=coastline, bbox 42.60–43.60/131.30–132.60, 14.11.2026), sha256 `a20213bd4467ec0b…`; добавлен V15 (вода/берег).
- `02_data/osm_buildings_vl.json` — здания OSM в границах Владивостокского ГО (73 100 контуров), вырезаны из Geofabrik far-eastern-fed-district-latest.osm.pbf (13.11.2026, md5 14da239f…) скриптом 05_code/osm_buildings_extract.py, 15.11.2026, sha256 `976e4c4dfe2e85be…`; добавлен T-014 (контуры домов).
- `02_data/osm_places.json` — выборка Overpass (бухты — 4×4 квадрата bbox 42.95–43.35/131.75–132.15, реки и острова — запросы по названиям; снимок базы 20.11.2026) скриптом 05_code/osm_places_fetch.py, 21.11.2026, sha256 `6d58b188e67dbcfa…`; добавлен T-025 (слой «бухты, реки, мысы»).
