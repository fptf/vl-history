# Слой домов (ФКР) для карты: buildings/ФКР_дома_с_координатами.csv -> 05_code/houses.json
# Запуск: python3 05_code/houses_prep.py (пути от файла скрипта, cwd не важен).
# houses.json в .gitignore — не коммитить.
#
# Логика:
# 1) Берём только «Муниципальное образование» == 'Владивостокский ГО' (город + спутники округа),
#    «Геокодирован» == 'да', валидные float Широта/Долгота, внутри bbox уличной сети (+5% запаса).
# 2) Сопоставление с улицами карты (02_data/streets_map.geojson, properties.name):
#    нормализация — lower, ё->е, знаки-разделители в пробел, слова-типы отбрасываются;
#    сокращения ФКР разворачиваются до полного типа (ул.->улица, пер.->переулок, пр-кт/пр-т->проспект,
#    ш.->шоссе, наб.->набережная, б-р->бульвар, туп.->тупик, мкр->микрорайон, п./пос.->поселок, г.->город),
#    ключ = отсортированные типы + отсортированные именные токены (порядок слов «Восточная 4-я» /
#    «4-я Восточная» не важен). Нет совпадения -> street_name_idx = null.
# 3) houses.json: {"decades":[...начальные годы десятилетий...], "materials":[...],
#    "street_names":[...имена из карты...],
#    "houses":[[x,y,decade_idx,mat_idx,floors,street_name_idx|null],...]}
#    Проекция и единицы как в prep.py (x,y в единицах 10 м, округлены до целых).
#    Соглашения: decade_idx=-1 (год неизвестен), mat_idx=-1 (материал не указан), floors=0 (этажи не указаны).
import csv, json, math, os, re, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
CSV_IN = os.path.join(ROOT, 'buildings', 'ФКР_дома_с_координатами.csv')
STREETS = os.path.join(ROOT, '02_data', 'streets_map.geojson')
OUT = os.path.join(HERE, 'houses.json')

MO = 'Владивостокский ГО'
csv.field_size_limit(10**7)

# --- проекция: формулы 1:1 из prep.py ---
lat0 = 43.11; kx = math.cos(math.radians(lat0)) * 111320; ky = 110574
lon0, latT = 131.70, 43.32
def proj(lon, lat):
    return ((lon - lon0) * kx / 10.0, (latT - lat) * ky / 10.0)  # units = 10 m

# --- нормализация названий улиц ---
FULL_TYPES = {'улица', 'переулок', 'проспект', 'шоссе', 'набережная', 'проезд',
              'тупик', 'бульвар', 'линия', 'микрорайон', 'поселок', 'город'}
ABB = {'ул': 'улица', 'пер': 'переулок', 'пр': 'проспект', 'пр-кт': 'проспект', 'пр-т': 'проспект',
       'ш': 'шоссе', 'наб': 'набережная', 'б-р': 'бульвар', 'бул': 'бульвар',
       'туп': 'тупик', 'мкр': 'микрорайон', 'пос': 'поселок', 'п': 'поселок', 'г': 'город'}

def toks(s):
    s = s.lower().replace('ё', 'е')
    out = []
    for w in re.split(r'[\s,;]+', s):
        w = w.strip('.').strip()
        if not w:
            continue
        w = ABB.get(w, w)          # сокращения типа -> полный тип
        for part in re.split(r'-+', w):  # 100-летия -> 100 летия
            if part:
                out.append(part)
    return out

def street_key(name):
    ts = toks(name)
    typ = tuple(sorted(t for t in ts if t in FULL_TYPES))
    rest = tuple(sorted(t for t in ts if t not in FULL_TYPES))
    return typ + rest if (typ or rest) else None

# --- улицы карты ---
features = json.load(open(STREETS, encoding='utf-8'))['features']
street_by_key = {}
for f in features:
    n = f['properties']['name']
    k = street_key(n)
    if k:
        street_by_key.setdefault(k, set()).add(n)
ambiguous = {k for k, v in street_by_key.items() if len(v) > 1}  # теоретически: 0

# bbox уличной сети (все точки линий, проекция prep.py) с запасом 5%
allx, ally = [], []
for f in features:
    g = f['geometry']
    for ln in (g['coordinates'] if g['type'] == 'MultiLineString' else [g['coordinates']]):
        for c in ln:
            x, y = proj(c[0], c[1])
            allx.append(x); ally.append(y)
bx0, bx1 = min(allx), max(allx); by0, by1 = min(ally), max(ally)
mx, my = (bx1 - bx0) * 0.05, (by1 - by0) * 0.05
bx0, bx1, by0, by1 = bx0 - mx, bx1 + mx, by0 - my, by1 + my

# --- строки ФКР ---
rows = list(csv.DictReader(open(CSV_IN, encoding='utf-8-sig')))
go = [r for r in rows if r['Муниципальное образование'] == MO]
n_geo_no = sum(1 for r in go if r['Геокодирован'] != 'да')
n_badcoord = 0
n_outside = 0
houses = []
for r in go:
    if r['Геокодирован'] != 'да':
        continue
    try:
        lat = float(r['Широта']); lon = float(r['Долгота'])
        assert 40 < lat < 50 and 130 < lon < 140
    except Exception:
        n_badcoord += 1
        continue
    x, y = proj(lon, lat)
    if not (bx0 <= x <= bx1 and by0 <= y <= by1):
        n_outside += 1
        continue
    ys = (r['Год постройки'] or '').strip()
    try:
        year = int(float(ys))
    except Exception:
        year = None
    mat = (r['Материал стен'] or '').strip()
    try:
        floors = int(float((r['Этажей'] or '').strip()))
    except Exception:
        floors = 0
    k = street_key(r['Улица'] or '')
    sn = None
    if k and k in street_by_key and k not in ambiguous:
        sn = next(iter(street_by_key[k]))
    houses.append(dict(x=round(x), y=round(y), year=year, mat=mat, floors=floors, street=sn))

# --- таблицы-справочники ---
years = sorted(h['year'] for h in houses if h['year'] is not None)
d0, d1 = years[0] // 10 * 10, years[-1] // 10 * 10
decades = list(range(d0, d1 + 1, 10))
mat_counter = collections.Counter(h['mat'] for h in houses if h['mat'])
materials = [m for m, _ in sorted(mat_counter.items(), key=lambda kv: (-kv[1], kv[0]))]
used_streets = sorted({h['street'] for h in houses if h['street']})
street_names = used_streets
mat_idx = {m: i for i, m in enumerate(materials)}
st_idx = {s: i for i, s in enumerate(street_names)}
dec_idx = {d: i for i, d in enumerate(decades)}

out = dict(
    decades=decades,
    materials=materials,
    street_names=street_names,
    houses=[[h['x'], h['y'],
             dec_idx[h['year'] // 10 * 10] if h['year'] is not None else -1,
             mat_idx[h['mat']] if h['mat'] in mat_idx else -1,
             h['floors'],
             st_idx[h['street']] if h['street'] is not None else None] for h in houses],
)
OUT_PATH = os.path.join(HERE, 'houses.json')
with open(OUT_PATH, 'w', encoding='utf-8') as f:
    json.dump(out, f, ensure_ascii=False, separators=(',', ':'))

# --- статистика ---
dec_cnt = collections.Counter((h['year'] // 10 * 10 if h['year'] is not None else None) for h in houses)
matched = sum(1 for h in houses if h['street'] is not None)
print(f'Строк ФКР всего: {len(rows)}; «{MO}»: {len(go)}')
print(f'Принято: {len(houses)} (геокодировано «нет»: {n_geo_no}, невалидные координаты: {n_badcoord}, вне bbox улиц: {n_outside})')
print(f'Сопоставлено с улицами карты: {matched} из {len(houses)} ({matched / len(houses) * 100:.1f} %); улиц в справочнике: {len(street_names)}')
if ambiguous:
    print(f'ВНИМАНИЕ: двусмысленных ключей улиц: {len(ambiguous)}: {sorted(next(iter(street_by_key[k])) for k in ambiguous)[:5]}')
print('Десятилетия постройки (домов):')
print('  ' + ' | '.join(f'{d}-е: {dec_cnt[d]}' for d in decades) + f' | без года: {dec_cnt[None]}')
print('Топ-5 материалов стен: ' + ' | '.join(f'{m}: {c}' for m, c in mat_counter.most_common(5)))
print(f'houses.json: {os.path.getsize(OUT_PATH)} байт, домов {len(houses)}')
