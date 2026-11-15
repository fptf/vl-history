# Здания OSM в границах Владивостокского городского округа: региональный PBF -> 02_data/osm_buildings_vl.json
# Запуск (нужны pyosmium и shapely, в обычной сборке не участвует — результат коммитится):
#   python3 05_code/osm_buildings_extract.py <путь к .osm.pbf>
# Источник PBF: Geofabrik, russia/far-eastern-fed-district-latest.osm.pbf (ODbL, © участники OpenStreetMap).
#
# 1) граница: relation boundary=administrative с name «Владивостокский городской округ»;
# 2) здания: ways и multipolygon-relations с тегом building=*, центроид внутри границы;
# 3) выход: {"source":…, "boundary":…, "buildings":[{"id":"w123","tags":{…},"rings":[[[lon,lat],…],…]}]}
#    координаты округлены до 1e-6 (≈ 0,1 м), из тегов — только нужные карте.
import json, sys, os, time
import osmium, shapely
from shapely import wkb
from shapely.prepared import prep

PBF = sys.argv[1]
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', '02_data', 'osm_buildings_vl.json')
GO_NAME = 'Владивостокский городской округ'
KEEP = ('building', 'building:levels', 'addr:street', 'addr:housenumber', 'addr:place', 'start_date', 'name')
wkbf = osmium.geom.WKBFactory()

# --- 1. граница округа
go = None
for a in osmium.FileProcessor(PBF).with_areas(osmium.filter.TagFilter(('boundary', 'administrative'))):
    if a.is_area() and a.tags.get('name') == GO_NAME and not a.from_way():
        go = wkb.loads(wkbf.create_multipolygon(a), hex=True)
        go_id = a.orig_id()
        break
if go is None:
    sys.exit('граница «%s» не найдена' % GO_NAME)
pgo = prep(go)
print('boundary relation', go_id, 'bbox', [round(v, 4) for v in go.bounds], flush=True)

# --- 2. здания
minx, miny, maxx, maxy = go.bounds
out = []
t0 = time.time()
fp = osmium.FileProcessor(PBF).with_areas(osmium.filter.KeyFilter('building')).with_filter(osmium.filter.KeyFilter('building'))
for a in fp:
    if not a.is_area():
        continue
    try:
        g = wkb.loads(wkbf.create_multipolygon(a), hex=True)
    except Exception:
        continue
    c = g.representative_point()
    if not (minx <= c.x <= maxx and miny <= c.y <= maxy) or not pgo.contains(c):
        continue
    rings = []
    for poly in getattr(g, 'geoms', [g]):
        rings.append([[round(x, 6), round(y, 6)] for x, y in poly.exterior.coords])
        for hole in poly.interiors:
            rings.append([[round(x, 6), round(y, 6)] for x, y in hole.coords])
    tags = {k: a.tags[k] for k in KEEP if k in a.tags}
    out.append({'id': ('w' if a.from_way() else 'r') + str(a.orig_id()), 'tags': tags, 'rings': rings})
print('buildings', len(out), 'in', round(time.time() - t0), 's', flush=True)

json.dump({'source': 'OpenStreetMap (ODbL), ' + os.path.basename(PBF),
           'boundary': 'relation %d «%s»' % (go_id, GO_NAME),
           'buildings': out},
          open(OUT, 'w', encoding='utf-8'), ensure_ascii=False, separators=(',', ':'))
print('saved', OUT, os.path.getsize(OUT), 'bytes')
