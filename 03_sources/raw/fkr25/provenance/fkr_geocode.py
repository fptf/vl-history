#!/usr/bin/env python3
# Геокодирование базы ФКР Приморья через prod-геокодер (<internal-geocoder-endpoint>).
# Чекпоинт в fkr_geo.jsonl, доусечённые фолбэки по формам города/улицы/дома.
import pandas as pd, json, re, time, sys, threading, urllib.request, urllib.parse
from concurrent.futures import ThreadPoolExecutor, as_completed

GEO = 'https://<internal-geocoder-host>/<internal-geocoder-endpoint>'
OUT = 'fkr_geo.jsonl'
LOCK_WRITE = __import__('threading').Lock()

df = pd.read_pickle('<workdir>/fkr_clean.pkl')

STREET_TYPES = {
    'ул.': 'улица', 'пер.': 'переулок', 'пр-кт': 'проспект', 'б-р': 'бульвар',
    'пл.': 'площадь', 'ш.': 'шоссе', 'мкр.': 'микрорайон', 'кв-л': 'квартал',
    'туп.': 'тупик', 'наб.': 'набережная', 'проезд': 'проезд',
}

def norm(s):
    if s is None:
        return ''
    return re.sub(r'\s+', ' ', str(s)).strip().lower().replace('ё', 'е')

def parse_addr(a):
    segs = [x.strip() for x in str(a).split(',') if x.strip()]
    # тип НП
    m = re.match(r'^([а-яё./]+)\s+(.+)$', segs[0])
    np = m.group(2) if m else segs[0]
    sub = None
    rest = segs[1:]
    if len(rest) >= 2:
        m2 = re.match(r'^([а-яё./]+\.?)\s+(.+)$', rest[0])
        if m2 and m2.group(1) in ('с.', 'п.', 'пгт.', 'пос.', 'о.', 'д.', 'кп.'):
            sub = m2.group(2)
            rest = rest[1:]
        elif 'микрорайон' in rest[0]:
            sub = re.sub(r'микрорайон\s*«?»?|«|»', '', rest[0]).replace('поселок ', '').strip()
            rest = rest[1:]
    street_raw = rest[0] if rest else ''
    house_raw = rest[1] if len(rest) > 1 else ''
    if len(rest) == 1 and re.match(r'^д\.\s*\d', rest[0]):
        house_raw, street_raw = rest[0], ''
    elif len(rest) == 1:
        house_raw = rest[0]
        street_raw = ''
    # нормализация улицы: «ул. X» → «улица X» / bare «X»
    street_full, street_bare = street_raw, re.sub(r'^[а-яё.\-]+\s+', '', street_raw, count=1)
    m3 = re.match(r'^([а-яё.\-]+)\s+(.*)$', street_raw)
    if m3 and m3.group(1) in STREET_TYPES:
        street_full = STREET_TYPES[m3.group(1)] + ' ' + m3.group(2)
        street_bare = m3.group(2)
    else:
        street_full = street_raw if street_raw else ''
    # формы дома
    h = house_raw.replace('д. ', '').strip()
    h_first = h.split(' ')[0]
    hcands = []
    for x in (h, h_first):
        x2 = re.sub(r'КОР\s+(\d)$', r'к\1', x, flags=re.I)
        x3 = re.sub(r'КОР\s+(\d)$', r'/\1', x, flags=re.I)
        x4 = re.sub(r'\s*строение\s+(\d)$', r'стр\1', x, flags=re.I)
        for v in (x, x2, x3, x4):
            v = v.strip()
            if v and v not in hcands:
                hcands.append(v)
    street_rev = ''
    m3r = re.match(r'^(мкр\.|кв-л)\s+(.+)$', street_raw)
    if m3r:
        word = 'микрорайон' if m3r.group(1) == 'мкр.' else 'квартал'
        street_rev = f'{m3r.group(2)} {word}'
    return norm(np), (norm(sub) if sub else None), street_full, street_bare, hcands, norm(street_raw), house_raw.strip(), street_rev

MO_MAP = {}
def district_form(mo, np_):
    if mo in MO_MAP:
        return MO_MAP[mo]
    mo = str(mo)
    if mo.startswith('МО г.'):
        f = mo.replace('МО г.', '').strip()
    elif mo.startswith('ЗАТО'):
        f = mo.replace('ЗАТО', '').strip()
    elif ' ГО' in mo:
        f = mo.replace(' ГО', ' городской округ').replace('МО ', '').strip()
    elif mo.endswith(' МО'):
        f = mo.replace(' МО', ' район')
    else:
        f = mo
    MO_MAP[mo] = f
    return f

def call(city, query, timeout=14):
    url = GEO + '?' + urllib.parse.urlencode({'query': query, 'city': city})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(url, timeout=timeout) as r:
                return json.loads(r.read().decode('utf-8'))
        except Exception:
            if attempt == 2:
                return {'status': 'error', 'landmarks': []}
            time.sleep(1.5 * (attempt + 1))

def verify(lm, np_, sub, street_bare, hcands):
    if lm.get('type') != 'address':
        return False
    hn = norm(lm.get('houseNum') or '')
    if hn not in {norm(x) for x in hcands}:
        return False
    rt = norm(lm.get('rawTitle') or '')
    full = norm(lm.get('fullTitle') or '')
    sb = norm(street_bare or '')
    if sb and sb not in rt and sb not in full:
        return False
    reg = norm(lm.get('region') or ('приморский край' if 'приморск' in full else ''))
    if reg := norm(lm.get('region')):
        if 'приморск' not in reg:
            return False
    ct = norm(lm.get('city') or '')
    if np_ and np_ not in ct and np_ not in full:
        if sub and (sub in ct or sub in full):
            return True
        return False
    return True

def geocode_row(i):
    a = df.at[i, 'Адрес МКД']
    np_, sub, sfull, sbare, hcands, sraw, hraw, srev = parse_addr(a)
    mo = df.at[i, 'МО']
    cities = []
    if sub:
        cities.append(sub)
    cities.append(np_)
    dform = district_form(mo, np_)
    if dform and dform != np_:
        cities.append(dform + ', ' + np_)
    tried = []
    sforms = [s for s in (sfull, sbare, srev) if s]
    for city in cities[:3]:
        for sform in sforms:
            for h in hcands[:3]:
                q = f'{sform} {h}'.strip()
                key = (norm(city), norm(sform), norm(h))
                if key in tried:
                    continue
                tried.append(key)
                d = call(city, q)
                for lm in (d.get('landmarks') or []):
                    if verify(lm, np_, sub, sbare, hcands):
                        return {'i': int(i), 'ok': 1, 'city_form': city, 'query': q,
                                'lat': lm.get('lat'), 'lon': lm.get('lon'),
                                'city': lm.get('city'), 'fullTitle': lm.get('fullTitle'),
                                'houseNum': lm.get('houseNum'), 'rawTitle': lm.get('rawTitle'),
                                'precision': lm.get('precision'), 'regionDistrict': lm.get('regionDistrict')}
    return {'i': int(i), 'ok': 0, 'city_form': cities[0] if cities else '', 'query': '', 'lat': None, 'lon': None}

def main():
    import os, json as _json
    done = set()
    if os.path.exists(OUT):
        with open(OUT) as fh:
            for line in fh:
                try:
                    done.add(_json.loads(line)['i'])
                except Exception:
                    pass
    todo = [i for i in df.index if i not in done]
    print(f'resume: done={len(done)} todo={len(todo)}', flush=True)
    t0 = time.time()
    n = 0
    n_ok = 0
    with ThreadPoolExecutor(max_workers=12) as ex, open(OUT, 'a', encoding='utf-8') as out:
        futs = {ex.submit(geocode_row, i): i for i in todo}
        for f in as_completed(futs):
            try:
                res = f.result()
            except Exception as e:
                res = {'i': int(futs[f]), 'ok': 0, 'err': str(e)[:100]}
            with LOCK_WRITE:
                out.write(_json.dumps(res, ensure_ascii=False) + '\n')
                if n % 50 == 0:
                    out.flush()
            n += 1
            n_ok += res.get('ok', 0)
            if n % 500 == 0:
                rate = n / (time.time() - t0)
                print(f'{n}/{len(todo)} ok={n_ok} rate={rate:.1f}/s eta={((len(todo)-n)/rate/60):.1f}m', flush=True)
    print(f'DONE {n} rows, ok={n_ok} ({n_ok/max(n,1)*100:.1f}%), {time.time()-t0:.0f}s', flush=True)

if __name__ == '__main__':
    main()
