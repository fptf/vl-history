# Манифест сырых данных (sha256)

Дата: 13.11.2026. Сюда входят сырые выгрузки и первоисточники проекта; производные файлы (классификация, карта, xlsx, HTML) — не сырьё, их происхождение описано в [../provenance.md](../provenance.md). Файлы лежат на своих местах, манифест ничего не перемещает.

Проверка из корня репозитория: `sha256sum -c 03_sources/raw/SHA256SUMS`

| Файл | Первоисточник | Дата | sha256 | Размер, байт |
|---|---|---|---|---|
| `02_data/ginfo_streets_raw.txt` | vladivostok.ginfo.ru/ulicy/; сырой список улиц: 820 строк «тип\|название» после чистки из 845 позиций | 13.11.2026 | `775622c9f52ef452…` | 21 194 |
| `02_data/vvmap_streets_years.csv` | github.com/skirienko/vvmap; сырая выгрузка vvmap: годы названий (1212 записей) | 13.11.2026 | `082b5ca68beae912…` | 147 008 |
| `02_data/vvmap_capes.geojson` | github.com/skirienko/vvmap; сырая выгрузка vvmap: мысы (точки) | 13.11.2026 | `3805b805f9004c5e…` | 22 032 |
| `buildings/ФКР_дома_с_координатами.csv` | fkr25.ru («Электронная база данных.xls») + геокодер Фарпоста; собран Вёрстом; 11 639 строк; первоисточник и метод — 03_sources/raw/fkr25/PROVENANCE_verst_answer.md | 13.11.2026 | `2353133b02ca50d2…` | 4 170 195 |
| `06_research/findings.jsonl` | веб-исследование V2 (URL в каждом вердикте «опознан»); сырые вердикты: 52 опознан (40 высокая + 12 предположительно), 33 не найдено | 13.11.2026 | `6e226761ad638a22…` | 60 168 |
| `03_sources/raw/fkr25/PROVENANCE_verst_answer.md` | агент «Вёрст» + протокол приёмки Болта; полный протокол происхождения ФКР-выгрузки | 13.11.2026 | `8fbef765e5e89299…` | 9 693 |
| `03_sources/raw/fkr25/provenance/fkr_fkr25.xls` | https://fkr25.ru/files/2014-2088/Электронная база данных.xls; первоисточник: приложение к Постановлению Администрации ПК от 31.12.2013 № 513-па | 13.11.2026 (Last-Modified сервера 30.04.2026) | `9a3d517964094e62…` | 4 276 736 |
| `03_sources/raw/fkr25/provenance/fkr_geocode.py` | агент «Вёрст»; скрипт геокодирования, пасс 1 | 13.11.2026 | `ac8ee134a086e954…` | 7 826 |
| `03_sources/raw/fkr25/provenance/fkr_geocode2.py` | агент «Вёрст»; скрипт до-геокодирования отказов | 13.11.2026 | `7c9ff62801161a04…` | 9 480 |
| `03_sources/raw/fkr25/provenance/fkr_assemble.py` | агент «Вёрст»; сборка buildings/ФКР_дома_с_координатами.csv | 13.11.2026 | `1ba7c6fc3d215eaa…` | 6 993 |
| `03_sources/raw/fkr25/provenance/fkr_geo.jsonl` | <internal-geocoder-host>/<internal-geocoder-endpoint>; сырые ответы геокодера, пасс 1 (10 643 принятых, все precision=exact) | 13.11.2026 | `67910902f758b1df…` | 5 335 056 |
| `03_sources/raw/fkr25/provenance/fkr_geo2.jsonl` | <internal-geocoder-host>/<internal-geocoder-endpoint>; сырые ответы геокодера, до-геокодирование | 13.11.2026 | `c3d70632664d981c…` | 63 603 |

Полные хэши — в блоке ниже и в `SHA256SUMS` (машинный формат sha256sum).

```
775622c9f52ef452fb01ada568042a818b7d1fa762c3ac4cf39cab1663ced347  02_data/ginfo_streets_raw.txt
082b5ca68beae912333827f6eecc17c0725e9c26954f94fc3f519620275173d3  02_data/vvmap_streets_years.csv
3805b805f9004c5e05f4bc2abb2d3ae5488bcb5c4dacd62b1abeb00f4f88a4fe  02_data/vvmap_capes.geojson
2353133b02ca50d23052f3ca2d41ee8fa18b0fb66572c3e1f841da42ba7d30d6  buildings/ФКР_дома_с_координатами.csv
6e226761ad638a223c7453037a541591484dd757aeb5211128ea7f755e697052  06_research/findings.jsonl
8fbef765e5e892998274114f2fcd3c4ea515c9a4e76b626ecd6afc545656952d  03_sources/raw/fkr25/PROVENANCE_verst_answer.md
9a3d517964094e62f447d0e33692b9136045457cb02dd6404de11ce5ccb82c16  03_sources/raw/fkr25/provenance/fkr_fkr25.xls
ac8ee134a086e954c7cae80ec8b784b77cbb55f8ffa0312e73790ee92a696e61  03_sources/raw/fkr25/provenance/fkr_geocode.py
7c9ff62801161a0466a62f890ccf911f549f26a8c4b536f5396d10761bef7314  03_sources/raw/fkr25/provenance/fkr_geocode2.py
1ba7c6fc3d215eaafc631d0c6a32dcaef877d940a198e5a00dfe2e0185db6981  03_sources/raw/fkr25/provenance/fkr_assemble.py
67910902f758b1df2dfcabae373acd0a9407150350f5ff5e23b5ab800873cdd9  03_sources/raw/fkr25/provenance/fkr_geo.jsonl
c3d70632664d981cee23b3248ac38012e8b7830cc73bad0f1ffb31096f26302b  03_sources/raw/fkr25/provenance/fkr_geo2.jsonl
```

## Чего в манифесте нет (честно)

- Сырых выгрузок страниц исследования V2 (`06_research/_*.html`/`_*.txt`) не существует: V2 сохранил только отчёт и `findings.jsonl` с URL источников, поэтому хэшировать нечего. Проверяемость — по URL в каждом вердикте.
- Классификация (`streets_classification.csv`), xlsx, `streets_map.geojson`, статистики и HTML — производные файлы, не сырые выгрузки; их происхождение — в provenance.md.

## Контрольная сумма манифеста

sha256 этого файла (посчитан по содержимому БЕЗ следующей строки):
`7dc2013b55ba121a06f7582755abe3c62e82e32ab8e94921779c54a6c86e5baf`
