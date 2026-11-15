# Сборка данных карты из репозитория: 02_data/streets_map.geojson + 02_data/vvmap_capes.geojson -> 05_code/data.json
# Запуск: python3 05_code/prep.py (пути считаются от файла скрипта, cwd не важен).
# Формулы проекции, упрощения (Douglas-Peucker) и кодирования SVG-пути сохранены 1:1 от исходного prep.py.
# Классификация берётся из properties самой geojson: group->g, theme->c, subtheme->s,
# confidence->u (u=1 если не «высокая»), note->o, part->pt, year->y, name->n, year_source->yd (без ссылок).
# T-001: src — индексы в общем списке ссылок на первоисточники (см. блок «первоисточники» ниже).
import json,re,math,os,collections
HERE=os.path.dirname(os.path.abspath(__file__))
DATA_DIR=os.path.join(HERE,'..','02_data')
fs=json.load(open(os.path.join(DATA_DIR,'streets_map.geojson'),encoding='utf-8'))['features']
capes=json.load(open(os.path.join(DATA_DIR,'vvmap_capes.geojson'),encoding='utf-8'))['features']
# ---------- первоисточники (T-001): компактные коды ссылок, шаблон разворачивает их в подпись + URL
#   d:<YYYYMMDD-N>  — текст постановления в репозитории vvmap (documents/<…>.md), только если файл есть в списке
#   t:<канал/N>     — пост в Telegram (t.me)
#   p:<YYYY.MM.DD-N> — постановление на topovl.ru (decree-<…>.html)
#   u:<url>         — прочие ссылки (веб-исследование 06_research)
import csv,urllib.parse
# Ссылки, проверенные 15.11.2026 и оказавшиеся битыми (404) — в карту не идут
BROKEN=set()
def clean_url(u):
    # хвостовая пунктуация из текста; «)» срезается, только если скобка непарная — (Владивосток) в URL Википедии
    u=urllib.parse.unquote(u.rstrip('.,;'))
    while u.endswith(')') and u.count(')')>u.count('('):u=u[:-1].rstrip('.,;')
    return u
VV_DOCS={l.strip()[:-3] for l in open(os.path.join(DATA_DIR,'vvmap_documents.txt'),encoding='utf-8') if l.strip().endswith('.md')}
VV_SRC={r['street']:(r['source'] or '').strip() for r in csv.DictReader(open(os.path.join(DATA_DIR,'vvmap_streets_years.csv'),encoding='utf-8'),delimiter=';')}
RESEARCH={}
for fn in ('findings.jsonl','findings2.jsonl'):  # волна 2 дополняет волну 1
    for l in open(os.path.join(HERE,'..','06_research',fn),encoding='utf-8'):
        x=json.loads(l)
        if x.get('status')!='опознан' or not x.get('source'):continue
        for k in (x['type']+' '+x['name'],x['name']+' '+x['type']):
            RESEARCH.setdefault(k,[])
            for u in re.findall(r'https?://[^\s;]+',x['source']):
                u=clean_url(u)
                if u not in RESEARCH[k]:RESEARCH[k].append(u)
def src_codes(name,year_source,note=''):
    codes=[]
    def add(c):
        if c not in codes:codes.append(c)
    for t in (VV_SRC.get(name,''),year_source):
        m=re.fullmatch(r'(\d{8}-\d+)\.md',t)
        if m and m.group(1) in VV_DOCS:add('d:'+m.group(1))
        for dd,mm,yy,no in re.findall(r'от (\d{2})\.(\d{2})\.(\d{4})\s*(?:г\.)?\s*[№N]\s*(\d+)',t):
            if yy+mm+dd+'-'+no in VV_DOCS:add('d:'+yy+mm+dd+'-'+no)
        for u in re.findall(r'https?://[^\s|]+',t):
            u=clean_url(u)
            if u in BROKEN:continue
            m=re.fullmatch(r'https://t\.me/(\w+/\d+)',u); m2=re.fullmatch(r'https://topovl\.ru/decree-([\d.]+-\d+)\.html',u)
            add('t:'+m.group(1) if m else 'p:'+m2.group(1) if m2 else 'u:'+u)
    # ссылки из примечания (вердикты V5: «… Источник: URL») — в список источников, из текста примечания убираются
    for u in re.findall(r'https?://[^\s;]+',note):
        u=clean_url(u)
        if u not in BROKEN:add('u:'+u)
    for u in RESEARCH.get(name,[]):
        if u not in BROKEN:add('u:'+u)
    return codes
SRCS=[];SRC_I={}
def src_ids(codes):
    ids=[]
    for c in codes:
        if c not in SRC_I:SRC_I[c]=len(SRCS);SRCS.append(c)
        ids.append(SRC_I[c])
    return ids

lat0=43.11; kx=math.cos(math.radians(lat0))*111320; ky=110574
lon0,latT=131.70,43.32
def proj(c): return ((c[0]-lon0)*kx/10.0,(latT-c[1])*ky/10.0)  # units = 10 m
def dp(pts,eps):
    if len(pts)<3: return pts
    a,b=pts[0],pts[-1]; dx,dy=b[0]-a[0],b[1]-a[1]; L=math.hypot(dx,dy) or 1e-9
    i,dm=0,0
    for k in range(1,len(pts)-1):
        p=pts[k]; d=abs(dy*p[0]-dx*p[1]+b[0]*a[1]-b[1]*a[0])/L
        if d>dm: i,dm=k,d
    if dm>eps: return dp(pts[:i+1],eps)[:-1]+dp(pts[i:],eps)
    return [a,b]
out=[]
for f in fs:
    p=f['properties']
    if 'мост' in p['name'] or 'посёлок' in p['name'] or 'поселок' in p['name']: continue
    g=f['geometry']; lines=g['coordinates'] if g['type']=='MultiLineString' else [g['coordinates']]
    d=''
    for ln in lines:
        pts=dp([proj(c) for c in ln],0.6)
        pts=[(round(x),round(y)) for x,y in pts]
        dd=[pts[0]]+[q for i,q in enumerate(pts[1:]) if q!=pts[i]]
        if len(dd)<2: dd=[pts[0],pts[-1]]
        d+='M'+str(dd[0][0])+' '+str(dd[0][1])+''.join('l%d %d'%(dd[i][0]-dd[i-1][0],dd[i][1]-dd[i-1][1]) for i in range(1,len(dd)))
    y=p.get('year','')
    try: y=int(y)
    except: y=None
    # yd: описание без ссылок — то же правило, что у старого скрипта для поля descr
    ys=str(p.get('year_source') or '')
    note=p.get('note','') or ''
    sc=src_ids(src_codes(p['name'],ys,note))
    note=re.sub(r'\s*Источник[и]?:\s*https?://.*$','',note,flags=re.S)
    out.append(dict(n=p['name'],g=p['group'],c=p['theme'],s=p['subtheme'],u=1 if p['confidence']!='высокая' else 0,o=note,y=y,yd=ys if not ys.startswith('http') and 'http' not in ys else '',pt=p.get('part'),d=d,**({'src':sc} if sc else {})))
print('features',len(out))
# V4: дома ФКР -> сегмент 'houses' (готовит houses_prep.py; если файла нет — дома не вливаются)
H_IN=os.path.join(HERE,'houses.json')
houses_seg=json.load(open(H_IN,encoding='utf-8')) if os.path.exists(H_IN) else None
print('houses', 'yes' if houses_seg else 'NO')
# V15: вода/берег -> сегмент 'water' (готовит water_prep.py; если файла нет — карты без воды)
W_IN=os.path.join(HERE,'water.json')
water_seg=json.load(open(W_IN,encoding='utf-8')) if os.path.exists(W_IN) else None
print('water', 'yes' if water_seg else 'NO')
cp=[]
for c in capes:
    x,y=proj(c['geometry']['coordinates']); cp.append([round(x),round(y),c['properties']['name']])
allx=[];ally=[]
for o in out:
    for m in re.finditer(r'M(-?\d+) (-?\d+)',o['d']): allx.append(int(m.group(1)));ally.append(int(m.group(2)))
print('bbox',min(allx),max(allx),min(ally),max(ally))
OUT=os.path.join(HERE,'data.json')
# Уникальные названия: одна улица может занимать несколько линий на карте
# (например, Школьная — в двух частях города). Нормализация: lower, ё->е, «-»->пробел,
# слова-типы отбрасываются, порядок слов не важен; если имя состоит только из
# слов-типов («Набережная улица», «улица Тупик») — типы сохраняем, чтобы не слить разные улицы.
STREET_TYPES={'улица','переулок','проспект','шоссе','набережная','проезд','тупик','бульвар','линия','микрорайон','поселок','город'}
def name_key(n):
    ws=n.lower().replace('ё','е').replace('-',' ').split()
    rest=tuple(sorted(w for w in ws if w not in STREET_TYPES))
    return rest if rest else tuple(sorted(ws))
keys=[name_key(o['n']) for o in out]
names_total=len(out); names_unique=len(set(keys)); names_multi=sum(1 for k,c in collections.Counter(keys).items() if c>1)
print('names_total',names_total,'names_unique',names_unique,'names_multi',names_multi)
print('sources: lines',sum(1 for o in out if o.get('src')),'unique links',len(SRCS))
json.dump(dict(f=out,capes=cp,srcs=SRCS,names_total=names_total,names_unique=names_unique,houses=houses_seg,water=water_seg),open(OUT,'w',encoding='utf-8'),ensure_ascii=False,separators=(',',':'))
print(os.path.getsize(OUT))
print(collections.Counter(o['g'] for o in out)); print(sum(1 for o in out if o['y'] is None))
