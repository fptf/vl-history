#!/usr/bin/env bash
# Сборка выгрузки «Топонимика улиц Владивостока» одной командой из корня репозитория:
#   bash 05_code/build.sh
# Нужны python3 и openpyxl (pip install -r 05_code/requirements.txt).
set -e
cd "$(dirname "$0")"
python3 classify.py    # 02_data/ginfo_streets_raw.txt -> 05_code/rows.json
python3 build.py       # rows.json -> 02_data/vladivostok_streets.xlsx
python3 prep.py        # 02_data/streets_map.geojson + vvmap_capes.geojson -> 05_code/data.json
python3 assemble.py    # data.json -> map_template.html.tpl -> 04_prototype/vladivostok-streets-map.html
