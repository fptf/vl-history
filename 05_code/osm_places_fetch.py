# T-025: геометрия бухт и рек OSM для слоя «бухты, реки, мысы» -> 02_data/osm_places.json
# Запуск вручную (нужна сеть; в обычной сборке не участвует — результат коммитится):
#   python3 05_code/osm_places_fetch.py [каталог-кэш]
# Overpass API. Бухты — bbox 42.95–43.35 / 131.75–132.15, 4×4 квадрата (запрос на весь bbox сервер обрывает 502/504);
# реки — один запрос по точным названиям, bbox 43.0–43.3 / 131.85–132.15. Ответы кэшируются в каталоге (по умолчанию — временный),
# повторный запуск докачивает недостающие.
# В выходной файл попадают только элементы, на которые ссылаются places.json (поле osm), с центром (бухты) или геометрией (реки).
# Данные: © участники OpenStreetMap, ODbL.
import json, os, sys, time, tempfile, urllib.request, urllib.parse
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
CACHE = sys.argv[1] if len(sys.argv) > 1 else os.path.join(tempfile.gettempdir(), 'vl_osm_places')
os.makedirs(CACHE, exist_ok=True)
S, W, N, E, n = 42.95, 131.75, 43.35, 132.15, 4
EPS = ['https://overpass-api.de/api/interpreter', 'https://maps.mail.ru/osm/tools/overpass/api/interpreter']
SEL = {'bay': ('nwr["natural"="bay"]["name"]', 'center', n, (S, W, N, E)),
       'river': ('way["waterway"~"^(river|stream)$"]["name"~"^(Богатая|Первая речка|Вторая речка|Объяснения)$"]', 'geom', 1,
                 (43.0, 131.85, 43.3, 132.15))}

def fetch(kind):
    els, stamps = [], set()
    sel, out, n, (S0, W0, N0, E0) = SEL[kind]
    for i in range(n):
        for j in range(n):
            s, nn = S0 + (N0 - S0) * i / n, S0 + (N0 - S0) * (i + 1) / n
            w, e = W0 + (E0 - W0) * j / n, W0 + (E0 - W0) * (j + 1) / n
            fn = os.path.join(CACHE, f'{kind}_{i}{j}.json')
            if not os.path.exists(fn):
                q = f'[out:json][timeout:60];{sel}({s:.4f},{w:.4f},{nn:.4f},{e:.4f});out tags {out};'
                for a in range(8):
                    try:
                        r = urllib.request.urlopen(urllib.request.Request(EPS[a % 2], data=urllib.parse.urlencode({'data': q}).encode(),
                                                   headers={'User-Agent': 'vl-history-map/1.0'}), timeout=90).read()
                        json.loads(r); open(fn, 'wb').write(r); break
                    except Exception as ex:
                        print(' retry', kind, i, j, str(ex)[:50], flush=True); time.sleep(10)
                else:
                    sys.exit(f'квадрат {kind} {i}{j} не скачан — запустите ещё раз')
                time.sleep(2)
            d = json.load(open(fn))
            stamps.add(d.get('osm3s', {}).get('timestamp_osm_base'))
            els += d['elements']
    return els, stamps

need = set()
for p in json.load(open(os.path.join(ROOT, '06_research', 'places.json'), encoding='utf-8'))['places']:
    need |= {k.strip() for k in p.get('osm', '').split(',') if k.strip()}
got, stamps = {}, set()
for kind in SEL:
    els, st = fetch(kind); stamps |= st
    for e in els:
        k = e['type'] + '/' + str(e['id'])
        if k not in need or k in got: continue
        x = {'type': e['type'], 'id': e['id'], 'name': e['tags'].get('name')}
        if 'center' in e: x['center'] = e['center']
        elif 'lat' in e: x['lat'], x['lon'] = e['lat'], e['lon']
        if 'geometry' in e: x['geometry'] = [{'lat': g['lat'], 'lon': g['lon']} for g in e['geometry']]
        got[k] = x
miss = sorted(need - set(got))
assert not miss, 'не найдены в OSM: ' + ', '.join(miss)
out = {'source': 'OpenStreetMap через Overpass API, © участники OpenStreetMap (ODbL)',
       'osm_base': [min(s for s in stamps if s), max(s for s in stamps if s)], 'bbox': {k: v[3] for k, v in SEL.items()},
       'elements': [got[k] for k in sorted(got)]}
p = os.path.join(ROOT, '02_data', 'osm_places.json')
open(p, 'w', encoding='utf-8').write(json.dumps(out, ensure_ascii=False, indent=1) + '\n')
print('osm_places:', len(got), 'элементов ->', p)
