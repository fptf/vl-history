#!/usr/bin/env python3
# Пасс 2: до-геокодирование неудач пасса 1 — токен-верификация улиц, инициалы,
# «7 к. 1»→«7к1», ГО-центры, о. Русский под Владивостоком.
import json, os, re, time, urllib.parse, urllib.request
import pandas as pd
from concurrent.futures import ThreadPoolExecutor, as_completed

GEO = 'https://<internal-geocoder-host>/<internal-geocoder-endpoint>'
OUT = '<workdir>/fkr_geo2.jsonl'

df = pd.read_pickle('<workdir>/fkr_clean.pkl')
ok_done = set()
with open('<workdir>/fkr_geo.jsonl') as fh:
    for line in fh:
        try:
            r = json.loads(line)
            if r.get('ok'):
                ok_done.add(r['i'])
        except Exception:
            pass

def norm(s):
    return re.sub(r'\s+', ' ', str(s)).strip().lower().replace('ё', 'е') if pd.notna(s) else ''

def norm_house(s):
    s = norm(s)
    s = s.replace(' ', '')
    s = re.sub(r'корп\.?|кор\.?', 'к', s)
    s = re.sub(r'строение', 'стр', s)
    s = re.sub(r'стр\.?', 'стр', s)
    return s

TYPE_FIRST = {'ул.': 'улица', 'пер.': 'переулок', 'пр-кт': 'проспект', 'б-р': 'бульвар',
              'пл.': 'площадь', 'ш.': 'шоссе', 'мкр.': 'микрорайон', 'кв-л': 'квартал',
              'туп.': 'тупик', 'наб.': 'набережная', 'пр-д': 'проезд'}
TYPE_LAST = {'пр-кт': 'проспект', 'пер': 'переулок', 'ул': 'улица', 'б-р': 'бульвар',
             'пл': 'площадь', 'ш': 'шоссе', 'туп': 'тупик', 'пр-д': 'проезд', 'мкр': 'микрорайон', 'кв-л': 'квартал'}
GO_CENTER = {
    'Владивостокский ГО': 'Владивосток', 'Находкинский ГО': 'Находка',
    'Уссурийский ГО': 'Уссурийск', 'Артемовский ГО': 'Артем', 'Арсеньевский ГО': 'Арсеньев',
    'Дальнереченский ГО': 'Дальнереченск', 'Дальнегорский МО': 'Дальнегорск',
    'МО г. Партизанск': 'Партизанск', 'МО Спасск-Дальний': 'Спасск-Дальний',
    'ЗАТО Большой Камень': 'Большой Камень', 'ЗАТО Фокино': 'Фокино',
}

def parse(a):
    segs = [x.strip() for x in str(a).split(',') if x.strip()]
    m = re.match(r'^([а-яё./]+)\s+(.+)$', segs[0])
    nptype, np = (m.group(1), m.group(2)) if m else ('', segs[0])
    rest = segs[1:]
    sub = None
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
    if len(rest) == 1:
        if re.match(r'^д\.\s*\d', rest[0]):
            house_raw, street_raw = rest[0], ''
        else:
            house_raw, street_raw = rest[0], ''
    house = re.sub(r'^д\.\s*', '', house_raw).strip()
    # формы улицы
    sforms = []
    bare = re.sub(r'^[а-яё.\-]+\s+', '', street_raw, count=1)
    m3 = re.match(r'^([а-яё.\-]+)\s+(.*)$', street_raw)
    if m3 and m3.group(1) in TYPE_FIRST:
        sforms.append(TYPE_FIRST[m3.group(1)] + ' ' + m3.group(2))
    bare = bare.strip()
    sforms.append(street_raw)
    sforms.append(bare)
    m4 = re.match(r'^(мкр\.|кв-л)\s+(.+)$', street_raw)
    if m4 := re.match(r'^(мкр\.|кв-л)\s+(.+)$', street_raw):
        sforms.append(f"{m4.group(2)} {'микрорайон' if m4.group(1) == 'мкр.' else 'квартал'}")
    m5 = re.match(r'^(.+?)\s+(пр-кт|пер|ул|б-р|пл|ш|туп|пр-д|мкр|кв-л)$', bare)
    if m5 and m5.group(2) in TYPE_LAST:
        sforms.append(f'{TYPE_LAST[m5.group(2)]} {m5.group(1)}')
    mi = re.match(r'^(?:[А-ЯЁ]\.\s*){1,2}\s*(.+)$', bare)
    if mi:
        sforms.append(mi.group(1).strip())
    m7 = re.match(r'^(.+?)\s+(?:[А-ЯЁ]\.\s*){1,2}$', bare)  # «Суворова А.В.» на оборот
    if m7:
        sforms.append(m7.group(1).strip())
    seen, out = set(), []
    for s in sforms:
        k = norm(s)
        if k and k not in seen:
            seen.add(k)
            out.append(s)
    return nptype, norm(np), (norm(sub) if sub else None), out, bare, house

def house_forms(h):
    forms = []
    h1 = h
    h2 = re.sub(r'\s*к(?:ор)?\.?\s*(\d+)$', r'к\1', h1, flags=re.I)
    h3 = re.sub(r'\s*кор\.?\s*(\d+)$', r' кор. \1', h1, flags=re.I)
    h4 = re.sub(r'\s*строение\s+(\d+)$', r'стр\1', h1, flags=re.I)
    h5 = h1.split(' ')[0]
    for v in (h1, h2, h3, h4, h5):
        v = v.strip()
        if v and v not in forms:
            forms.append(v)
    return forms

def call(city, query):
    url = GEO + '?' + urllib.parse.urlencode({'query': query, 'city': city})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(url, timeout=14) as r:
                return json.loads(r.read().decode('utf-8'))
        except Exception:
            if attempt == 2:
                return {'status': 'error', 'landmarks': []}
            time.sleep(1.2 * (attempt + 1))

def verify(lm, np_, sub, street_bare, house, nptype):
    if lm.get('type') != 'address':
        return False
    hn = norm_house(lm.get('houseNum') or '')
    if hn != norm_house(house):
        return False
    full = norm(lm.get('fullTitle') or '')
    rt = norm(lm.get('rawTitle') or '')
    sb = norm(street_bare)
    toks = [t for t in sb.split() if len(t) > 1]
    if not (sb in rt or sb in full):
        if not toks or not all(t in full for t in toks):
            return False
    reg = norm(lm.get('region'))
    if reg and 'приморск' not in reg:
        return False
    ct = norm(lm.get('city') or '')
    if nptype == 'о.':
        return True
    if np_ and (np_ in ct or np_ in full):
        return True
    if sub and (sub in ct or sub in full):
        return True
    return False

def geocode(i):
    a = df.at[i, 'Адрес МКД']
    nptype, np_, sub, sforms, bare, house = parse(a)
    mo = str(df.at[i, 'МО'])
    cities = []
    if sub:
        cities.append(sub)
    cities.append(np_)
    dform = mo.replace(' ГО', ' городской округ').replace('МО ', '').replace(' МО', ' район')
    if mo.startswith('МО г.'):
        dform = mo.replace('МО г.', '').strip()
    elif mo.startswith('ЗАТО'):
        dform = mo.replace('ЗАТО', '').strip()
    if dform and dform != np_:
        cities.append(dform + ', ' + np_)
    goc = GO_CENTER.get(mo)
    if goc and norm(goc) not in {norm(c) for c in cities}:
        cities.append(goc)
    tried = set()
    for city in cities[:4]:
        for sform in sforms:
            for h in house_forms(house):
                q = f'{sform} {h}'.strip()
                key = (norm(city), norm(sform), norm_house(h))
                if key in tried:
                    continue
                tried.add(key)
                d = call(city, q)
                for lm in (d.get('landmarks') or []):
                    if verify(lm, np_, sub, bare, house, nptype):
                        return {'i': int(i), 'ok': 1, 'city_form': city, 'query': q,
                                'lat': lm.get('lat'), 'lon': lm.get('lon'),
                                'city': lm.get('city'), 'fullTitle': lm.get('fullTitle'),
                                'houseNum': lm.get('houseNum'), 'rawTitle': lm.get('rawTitle'),
                                'precision': lm.get('precision'), 'regionDistrict': lm.get('regionDistrict')}
    return {'i': int(i), 'ok': 0}

def main():
    import threading
    todo = [i for i in df.index if i not in ok_done]
    done2 = set()
    if os.path.exists(OUT):
        with open(OUT) as fh:
            for line in fh:
                try:
                    r = json.loads(line)
                    if r.get('ok'):
                        done2.add(r['i'])
                except Exception:
                    pass
    todo = [i for i in todo if i not in done2]
    print(f'pass2: todo={len(todo)} (ok from pass1: {len(ok_done)})', flush=True)
    t0 = time.time()
    n = n_ok = 0
    lk = threading.Lock()
    with ThreadPoolExecutor(max_workers=8) as ex, open(OUT, 'a', encoding='utf-8') as out:
        futs = {ex.submit(geocode, i): i for i in todo}
        for f in as_completed(futs):
            try:
                res = f.result()
            except Exception as e:
                res = {'i': int(futs[f]), 'ok': 0, 'err': str(e)[:80]}
            with lk:
                out.write(json.dumps(res, ensure_ascii=False) + '\n')
                if n % 50 == 0:
                    out.flush()
            n += 1
            n_ok += res.get('ok', 0)
            if n % 200 == 0:
                print(f'{n}/{len(todo)} ok={n_ok} rate={n/(time.time()-t0):.1f}/s', flush=True)
    print(f'PASS2 DONE {n} rows, newly ok={n_ok}, {time.time()-t0:.0f}s', flush=True)

if __name__ == '__main__':
    main()
