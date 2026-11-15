# Контуры зданий для карты (T-014): 02_data/osm_buildings_vl.json + houses.json/houses_geo.json
#   -> 04_prototype/vladivostok-streets-map.buildings.js (отдельный файл рядом с картой, грузится по требованию)
# Запуск: python3 05_code/buildings_prep.py (после houses_prep.py; только стандартная библиотека).
#
# 1) Проекция как в prep.py, но в метрах (×10) и с округлением до 1 м; контур упрощается (Douglas-Peucker, 0,7 м).
# 2) Дом ФКР -> здание OSM: контур, содержащий точку геокодера (из нескольких — наименьший);
#    иначе ближайший контур не дальше MAX_D м. Одно здание может получить несколько домов ФКР (корпуса, секции).
# 3) Выход: window.VL_BUILDINGS = {"u": "<путь SVG всех прочих зданий>", "f": [[индекс дома ФКР, "<путь>"], …]}
#    Пути — в метрах проекции (M x y l dx dy … z), рисуются через Path2D.
import json, math, os, re, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
B_IN = os.path.join(ROOT, '02_data', 'osm_buildings_vl.json')
H_IN = os.path.join(HERE, 'houses.json')
G_IN = os.path.join(HERE, 'houses_geo.json')
OUT = os.path.join(ROOT, '04_prototype', 'vladivostok-streets-map.buildings.js')
MAX_D = 25.0   # м: дом ФКР вне контуров — к ближайшему зданию не дальше
EPS = 0.7      # м: допуск упрощения контура

lat0 = 43.11; kx = math.cos(math.radians(lat0)) * 111320; ky = 110574
lon0, latT = 131.70, 43.32
def proj_m(lon, lat): return ((lon - lon0) * kx, (latT - lat) * ky)  # метры (в prep.py — единицы по 10 м)

def dp(pts, eps):
    if len(pts) < 3: return pts
    (x1, y1), (x2, y2) = pts[0], pts[-1]
    dx, dy = x2 - x1, y2 - y1; L = math.hypot(dx, dy) or 1e-9
    k, dmax = 0, -1
    for i in range(1, len(pts) - 1):
        d = abs(dy * (pts[i][0] - x1) - dx * (pts[i][1] - y1)) / L
        if d > dmax: k, dmax = i, d
    if dmax <= eps: return [pts[0], pts[-1]]
    return dp(pts[:k + 1], eps)[:-1] + dp(pts[k:], eps)

def simplify_ring(r):
    if len(r) <= 5: return r
    # замкнутое кольцо: делим на две половины по самой дальней от первой точке
    far = max(range(len(r)), key=lambda i: (r[i][0] - r[0][0]) ** 2 + (r[i][1] - r[0][1]) ** 2)
    out = dp(r[:far + 1], EPS)[:-1] + dp(r[far:] + [r[0]], EPS)[:-1]
    return out if len(out) >= 3 else r

def area(r): return abs(sum(r[i][0] * r[i - 1][1] - r[i - 1][0] * r[i][1] for i in range(len(r)))) / 2
def pip(x, y, r):
    ins = False; n = len(r)
    for i in range(n):
        x1, y1 = r[i]; x2, y2 = r[i - 1]
        if (y1 > y) != (y2 > y) and x < (x2 - x1) * (y - y1) / (y2 - y1) + x1: ins = not ins
    return ins
def seg_d2(px, py, a, b):
    (x1, y1), (x2, y2) = a, b; dx, dy = x2 - x1, y2 - y1
    t = max(0, min(1, ((px - x1) * dx + (py - y1) * dy) / ((dx * dx + dy * dy) or 1e-9)))
    return (x1 + t * dx - px) ** 2 + (y1 + t * dy - py) ** 2

# --- здания OSM -> кольца в метрах
B = json.load(open(B_IN, encoding='utf-8'))['buildings']
blds = []
for b in B:
    rings = []
    for r in b['rings']:
        pts = [proj_m(lon, lat) for lon, lat in r[:-1]]
        pts = [(round(x), round(y)) for x, y in pts]
        pts = [p for i, p in enumerate(pts) if p != pts[i - 1]]
        if len(pts) >= 3: rings.append(simplify_ring(pts))
    if rings: blds.append(rings)
# сетка 200 м для поиска
CELL = 200
grid = collections.defaultdict(list)
bbox = []
for k, rings in enumerate(blds):
    xs = [p[0] for p in rings[0]]; ys = [p[1] for p in rings[0]]
    bb = (min(xs), min(ys), max(xs), max(ys)); bbox.append(bb)
    for gx in range(int(bb[0] // CELL), int(bb[2] // CELL) + 1):
        for gy in range(int(bb[1] // CELL), int(bb[3] // CELL) + 1):
            grid[(gx, gy)].append(k)

# --- дома ФКР -> здания
H = json.load(open(H_IN, encoding='utf-8'))['houses']
G = json.load(open(G_IN, encoding='utf-8'))
assert len(G) == len(H), 'houses_geo.json не соответствует houses.json — перезапустите houses_prep.py'
match = {}; how = collections.Counter()
for hi, (lon, lat) in enumerate(G):
    x, y = proj_m(lon, lat)
    cand = set()
    for gx in range(int((x - MAX_D) // CELL), int((x + MAX_D) // CELL) + 1):
        for gy in range(int((y - MAX_D) // CELL), int((y + MAX_D) // CELL) + 1):
            cand.update(grid.get((gx, gy), ()))
    inside = [k for k in cand if bbox[k][0] <= x <= bbox[k][2] and bbox[k][1] <= y <= bbox[k][3] and pip(x, y, blds[k][0])]
    if inside:
        match[hi] = min(inside, key=lambda k: area(blds[k][0])); how['inside'] += 1; continue
    best, bd = None, MAX_D ** 2
    for k in cand:
        r = blds[k][0]
        for i in range(len(r)):
            d = seg_d2(x, y, r[i - 1], r[i])
            if d < bd: best, bd = k, d
    if best is not None: match[hi] = best; how['near'] += 1
    else: how['none'] += 1

def path(rings):
    s = ''
    for r in rings:
        s += 'M%d %d' % r[0] + ''.join('l%d %d' % (r[i][0] - r[i - 1][0], r[i][1] - r[i - 1][1]) for i in range(1, len(r))) + 'z'
    return s
fkr_b = set(match.values())
under = ''.join(path(rings) for k, rings in enumerate(blds) if k not in fkr_b)
fkr = [[hi, path(blds[k])] for hi, k in sorted(match.items())]
js = 'window.VL_BUILDINGS=' + json.dumps({'u': under, 'f': fkr}, ensure_ascii=False, separators=(',', ':')) + ';\n'
open(OUT, 'w', encoding='utf-8').write(js)
print(f'зданий OSM: {len(blds)}; домов ФКР: {len(H)} — внутри контура {how["inside"]}, рядом (≤{MAX_D:.0f} м) {how["near"]}, без контура {how["none"]}')
print(f'зданий с домами ФКР: {len(fkr_b)}; подложка: {len(blds) - len(fkr_b)} зданий, {len(under)} байт')
print(f'{os.path.basename(OUT)}: {os.path.getsize(OUT)} байт')
