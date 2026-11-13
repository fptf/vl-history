#!/usr/bin/env python3
# Сборка: ФКР-таблица + координаты геокодера → xlsx со сводкой.
import json, os, sys
import pandas as pd

df = pd.read_pickle('<workdir>/fkr_clean.pkl')

geo = {}
for src in ('<workdir>/fkr_geo.jsonl', '<workdir>/fkr_geo2.jsonl'):
    if not os.path.exists(src):
        continue
    with open(src) as fh:
        for line in fh:
            try:
                r = json.loads(line)
            except Exception:
                continue
            if r.get('ok') and (r['i'] not in geo or not geo[r['i']].get('ok')):
                geo[r['i']] = r

# откат ложных совпадений (проверка по городу поиска/островному bbox)
REV = '<workdir>/fkr_revert.pkl'
if os.path.exists(REV):
    reverted = pd.read_pickle(REV)
    for i in reverted:
        if i in geo:
            geo[i]['ok'] = 0
            geo[i]['lat'] = None
            geo[i]['lon'] = None
    print('reverted suspicious matches:', len(reverted))

print('geo ok:', sum(1 for v in geo.values() if v.get('ok')), 'of', len(df))

REPAIR_NAMES = [
    'Ремонт систем теплоснабжения',
    'Ремонт систем электроснабжения',
    'Ремонт систем холодного водоснабжения',
    'Ремонт систем водоотведения',
    'Ремонт систем горячего водоснабжения',
    'Ремонт систем газоснабжения',
    'Ремонт лифтов (замена, модернизация, шахты)',
    'Ремонт крыши (вкл. чердачное перекрытие)',
    'Ремонт подвальных помещений',
    'Ремонт фасада',
    'Ремонт фундамента',
    'Установка коллективных ПУ и УУ',
    'Проектная и сметная документация, экспертиза',
    'Строительный контроль',
    'Государственная историко-культурная экспертиза, авторский надзор',
]

def split_addr(a):
    segs = [x.strip() for x in str(a).split(',') if x.strip()]
    import re
    m = re.match(r'^([а-яё./]+)\s+(.+)$', segs[0])
    np_type, np = (m.group(1), m.group(2)) if m else ('', segs[0])
    rest = segs[1:]
    sub = ''
    if len(rest) >= 2:
        m2 = re.match(r'^([а-яё./]+\.?)\s+(.+)$', rest[0])
        if m2 and m2.group(1) in ('с.', 'п.', 'пгт.', 'пос.', 'о.', 'д.', 'кп.'):
            sub = rest[0]
            rest = rest[1:]
        elif 'микрорайон' in rest[0]:
            sub = rest[0]
            rest = rest[1:]
    street = rest[0] if rest else ''
    house = rest[1] if len(rest) > 1 else (rest[0] if rest and re.match(r'^д\.\s*\d', rest[0] if rest else '') else '')
    if len(rest) == 1 and re.match(r'^д\.\s*\d', rest[0]):
        street, house = '', rest[0]
    elif len(rest) == 1:
        street, house = '', rest[0]
    house = re.sub(r'^д\.\s*', '', house)
    return np_type, np, sub, street, house

rows = []
for i in df.index:
    a = df.at[i, 'Адрес МКД']
    np_type, np, sub, street, house = split_addr(a)
    g = geo.get(i, {})
    lat, lon = g.get('lat'), g.get('lon')
    full = a + (' (' + sub + ')' if sub and sub not in a else '')
    row = {
        '№ строки': int(i) + 1,
        'Муниципальное образование': df.at[i, 'МО'],
        'Нас. пункт': np,
        'Пригород/мкр': sub,
        'Улица': street,
        'Дом': house,
        'Полный адрес (ФКР)': a,
        'Широта': round(lat, 6) if lat else None,
        'Долгота': round(lon, 6) if lon else None,
        'Координаты': f'{lat:.6f}, {lon:.6f}' if lat else '',
        'Геокодирован': 'да' if lat else 'нет',
        'Год постройки': int(df.at[i, 'Год ввода']) if pd.notna(df.at[i, 'Год ввода']) else None,
        'Материал стен': df.at[i, 'Материал стен'],
        'Этажей': int(df.at[i, 'Этажей']) if pd.notna(df.at[i, 'Этажей']) else None,
        'Подъездов': int(df.at[i, 'Подъездов']) if pd.notna(df.at[i, 'Подъездов']) else None,
        'Общая площадь, м²': round(float(df.at[i, 'Общая площадь']), 2) if pd.notna(df.at[i, 'Общая площадь']) else None,
        'Площадь помещений, м²': round(float(df.at[i, 'Площадь помещений']), 2) if pd.notna(df.at[i, 'Площадь помещений']) else None,
        'Последний капремонт': df.at[i, 'Последний капремонт'],
    }
    for k, name in enumerate(REPAIR_NAMES):
        v = df.at[i, f'repair_{k}']
        row[name] = v if pd.notna(v) else None
    rows.append(row)

out = pd.DataFrame(rows)
for col in ('Год постройки', 'Этажей', 'Подъездов'):
    out[col] = out[col].astype('Int64')
print('rows:', len(out), '| geocoded:', (out['Геокодирован'] == 'да').sum(),
      f"({(out['Геокодирован'] == 'да').mean()*100:.1f}%)")
out.to_pickle('<workdir>/fkr_final.pkl')

# ---- xlsx
import os
path = '<data-dir>/ФКР_дома_с_координатами.xlsx'
os.makedirs(os.path.dirname(path), exist_ok=True)
with pd.ExcelWriter(path, engine='openpyxl') as xw:
    out.to_excel(xw, sheet_name='Дома', index=False)
    # сводка по МО
    sv = out.groupby('Муниципальное образование').agg(
        Домов=('№ строки', 'count'),
        С_координатами=('Геокодирован', lambda s: (s == 'да').sum()),
    ).reset_index()
    sv['% с координатами'] = (sv['С_координатами'] / sv['Домов'] * 100).round(1)
    sv = sv.sort_values('Домов', ascending=False)
    sv.to_excel(xw, sheet_name='Сводка по МО', index=False)
    # по годам постройки
    gy = out.dropna(subset=['Год постройки']).groupby('Год постройки').agg(
        Домов=('№ строки', 'count'),
        С_координатами=('Геокодирован', lambda s: (s == 'да').sum()),
    ).reset_index()
    gy['Год постройки'] = gy['Год постройки'].astype(int)
    gy.to_excel(xw, sheet_name='По годам постройки', index=False)
    nf = out[out['Геокодирован'] == 'нет'][
        ['Муниципальное образование', 'Нас. пункт', 'Улица', 'Дом', 'Полный адрес (ФКР)', 'Год постройки']]
    nf.to_excel(xw, sheet_name='Без координат', index=False)
print('xlsx written:', path)
