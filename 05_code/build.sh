#!/usr/bin/env bash
# Сборка выгрузки «Топонимика улиц Владивостока» одной командой из корня репозитория:
#   bash 05_code/build.sh
# Нужны python3 и openpyxl (pip install -r 05_code/requirements.txt).
set -e
cd "$(dirname "$0")"
python3 classify.py    # 02_data/ginfo_streets_raw.txt -> 05_code/rows.json
python3 build.py       # rows.json -> 02_data/vladivostok_streets.xlsx
python3 houses_prep.py # 02_data/ФКР_дома_с_координатами.csv -> 05_code/houses.json (+ houses_geo.json)
python3 buildings_prep.py # 02_data/osm_buildings_vl.json + дома -> 04_prototype/vladivostok-streets-map.buildings.js (T-014)
python3 water_prep.py  # 02_data/osm_coastline_raw.json -> 05_code/water.json (V15)
python3 prep.py        # 02_data/streets_map.geojson + vvmap_capes.geojson + houses.json + water.json -> 05_code/data.json
python3 assemble.py    # data.json -> map_template.html.tpl -> 04_prototype/vladivostok-streets-map.html
