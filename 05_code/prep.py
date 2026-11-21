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
# ключ без учёта регистра и ё/е: у vvmap «улица Героя России Жоги», «улица Военное Шоссе», у нас — со строчной
_vk=lambda n:n.lower().replace('ё','е')
VV_SRC={_vk(r['street']):(r['source'] or '').strip() for r in csv.DictReader(open(os.path.join(DATA_DIR,'vvmap_streets_years.csv'),encoding='utf-8'),delimiter=';')}
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
    for t in (VV_SRC.get(_vk(name),''),year_source):
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
# T-023: справки об улицах из статей (06_research/articles.json) -> поле a=[[индекс статьи, текст],…], список статей arts=[[url, подпись, заголовок],…]
_AJ=json.load(open(os.path.join(HERE,'..','06_research','articles.json'),encoding='utf-8'))
ARTS=[[a['url'],a['label'],a['title']] for a in _AJ['articles']]
_AI={a['id']:k for k,a in enumerate(_AJ['articles'])}
ART_NOTES={}
for x in _AJ['notes']:ART_NOTES.setdefault(x['street'],[]).append([_AI[x['article']],x['text']])
_names={f['properties']['name'] for f in fs}
_miss=[n for n in ART_NOTES if n not in _names]
assert not _miss,'articles.json: нет таких улиц в geojson: '+', '.join(_miss)
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
    out.append(dict(n=p['name'],g=p['group'],c=p['theme'],s=p['subtheme'],u=1 if p['confidence']!='высокая' else 0,o=note,y=y,yd=ys if not ys.startswith('http') and 'http' not in ys else '',pt=p.get('part'),d=d,**({'src':sc} if sc else {}),**({'a':ART_NOTES[p['name']]} if p['name'] in ART_NOTES else {})))
print('features',len(out))
# V4: дома ФКР -> сегмент 'houses' (готовит houses_prep.py; если файла нет — дома не вливаются)
H_IN=os.path.join(HERE,'houses.json')
houses_seg=json.load(open(H_IN,encoding='utf-8')) if os.path.exists(H_IN) else None
print('houses', 'yes' if houses_seg else 'NO')
# V15: вода/берег -> сегмент 'water' (готовит water_prep.py; если файла нет — карты без воды)
W_IN=os.path.join(HERE,'water.json')
water_seg=json.load(open(W_IN,encoding='utf-8')) if os.path.exists(W_IN) else None
print('water', 'yes' if water_seg else 'NO')
# T-013: местность линии — по координатам, а не по полю part (оно ненадёжно: 26 линий на о. Русском помечены mainland).
# Острова — по кольцам суши из water.json (точка середины линии внутри кольца); кольцо острова получает метку
# большинством голосов part его линий. На материке part надёжен: peschany / trudovoe / прочее = город.
# Коды: r — о. Русский, p — о. Попова, k — о. Рейнеке, s — п-ов Песчаный, t — Трудовое, '' — город.
PART_LOC={'russky':'r','popova':'p','reineke':'k','peschany':'s','trudovoe':'t'}
def path_pts(d):
    pts=[];x=y=0
    for cmd,a_,b_ in re.findall(r'([Ml])(-?\d+) (-?\d+)',d):
        a_,b_=int(a_),int(b_)
        if cmd=='M':x,y=a_,b_
        else:x+=a_;y+=b_
        pts.append((x,y))
    return pts
def pip(pt,r):
    x,y=pt;ins=False;n=len(r)
    for i in range(n):
        x1,y1=r[i];x2,y2=r[(i+1)%n]
        if (y1>y)!=(y2>y) and x<(x2-x1)*(y-y1)/(y2-y1)+x1:ins=not ins
    return ins
def ring_area(r):return abs(sum(r[i][0]*r[(i+1)%len(r)][1]-r[(i+1)%len(r)][0]*r[i][1] for i in range(len(r))))/2
rings=[path_pts(sp) for sp in re.findall(r'M[^M]*',water_seg['d'])[1:]] if water_seg else []
main_ring=max(range(len(rings)),key=lambda k:ring_area(rings[k])) if rings else None
def ring_of(pt):
    ins=[k for k,r in enumerate(rings) if pip(pt,r)]
    return min(ins,key=lambda k:ring_area(rings[k])) if ins else None
line_pts=[path_pts(o['d']) for o in out]
line_ring=[ring_of(P[len(P)//2]) for P in line_pts]
votes=collections.defaultdict(collections.Counter)
for o,k in zip(out,line_ring):
    if k is not None and k!=main_ring and PART_LOC.get(o['pt']):votes[k][PART_LOC[o['pt']]]+=1
ring_loc={k:c.most_common(1)[0][0] for k,c in votes.items()}
n_fixed=0
for o,k in zip(out,line_ring):
    loc=ring_loc.get(k) if (k is not None and k!=main_ring) else None
    if loc is None:loc=PART_LOC.get(o['pt'],'') if o['pt'] in ('peschany','trudovoe') else ('' if rings else PART_LOC.get(o['pt'],''))
    if loc!=PART_LOC.get(o['pt'],''):n_fixed+=1
    if loc:o['l']=loc
print('locality: fixed vs part',n_fixed,collections.Counter(o.get('l','') for o in out))
# дома одноимённых улиц: к линии того же названия, ближайшей к дому (код местности — h[8])
by_name_loc=collections.defaultdict(set)
for o in out:by_name_loc[o['n']].add(o.get('l',''))
if houses_seg:
    names=houses_seg['street_names'];n_amb=0
    for h in houses_seg['houses']:
        if h[5] is None:continue
        nm=names[h[5]]
        if len(by_name_loc.get(nm,()))<2:continue
        best=min((min((h[0]-x)**2+(h[1]-y)**2 for x,y in line_pts[i]),out[i].get('l','')) for i,o in enumerate(out) if o['n']==nm)
        while len(h)<8:h.append(None)
        h[8:]=[best[1]];n_amb+=1
    print('houses on same-named streets',n_amb)
cp=[]
for c in capes:
    x,y=proj(c['geometry']['coordinates']); cp.append([round(x),round(y),c['properties']['name']])
# T-025: слой объектов (бухты, реки, мысы) со справками из статей — 06_research/places.json.
# Бухты/реки: геометрия OSM из 02_data/osm_places.json (id в поле osm; у реки — несколько way через запятую);
# мысы: точки из vvmap_capes, со справкой — переносятся из capes в places (чтобы не было двойной подписи).
# Элемент: dict(t=bay|river|cape, n=имя, x,y = точка подписи, d = путь реки (как у улиц), a=[[статья,текст],…])
PJ=json.load(open(os.path.join(HERE,'..','06_research','places.json'),encoding='utf-8'))
OP={e['type']+'/'+str(e['id']):e for e in json.load(open(os.path.join(DATA_DIR,'osm_places.json'),encoding='utf-8'))['elements']}
PL=[]; cape_xy={c[2]:c for c in cp}
for pl in PJ['places']:
    notes=[[_AI[x['article']],x['text']] for x in PJ['notes'] if x['place']==pl['name']]
    assert notes,'places.json: нет справок у '+pl['name']
    if pl['kind']=='cape':
        c=cape_xy.pop(pl['name']); PL.append(dict(t='cape',n=pl['name'],x=c[0],y=c[1],a=notes)); continue
    if 'll' in pl:  # нет в OSM: точка из проверенного источника (поле src — в карточку)
        x,y=proj((pl['ll'][1],pl['ll'][0])); PL.append(dict(t=pl['kind'],n=pl['name'],x=round(x),y=round(y),a=notes,s=pl['src'])); continue
    els=[OP[k.strip()] for k in pl['osm'].split(',')]
    if pl['kind'] in ('bay','island','strait'):
        e=els[0]; ll=e.get('center') or {'lat':e['lat'],'lon':e['lon']}
        x,y=proj((ll['lon'],ll['lat'])); PL.append(dict(t=pl['kind'],n=pl['name'],x=round(x),y=round(y),a=notes)); continue
    d='';best=[]
    for e in els:
        pts=dp([proj((g['lon'],g['lat'])) for g in e['geometry']],0.6); pts=[(round(x),round(y)) for x,y in pts]
        dd=[pts[0]]+[q for i,q in enumerate(pts[1:]) if q!=pts[i]]
        if len(dd)<2: continue
        d+='M%d %d'%dd[0]+''.join('l%d %d'%(dd[i][0]-dd[i-1][0],dd[i][1]-dd[i-1][1]) for i in range(1,len(dd)))
        if len(dd)>len(best): best=dd
    mx,my=best[len(best)//2]
    PL.append(dict(t='river',n=pl['name'],x=mx,y=my,d=d,a=notes))
cp=[c for c in cp if c[2] in cape_xy]
print('places',len(PL),{k:sum(1 for p in PL if p['t']==k) for k in ('bay','strait','island','peninsula','river','cape')})
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
# фильтр «Источники» (T-035): у каждой линии — группы источников сведений о названии и годе (поле sg, индексы в SG).
# Название улицы — из списка ginfo.ru, геометрия — OSM через vvmap; группы ниже — откуда год/справка.
# «vvmap (первоисточник не указан)» — запись vvmap только с описанием или годом.
SG=['Постановления','Справочник 1924 г.','Списки 1954 и 1957 гг.','Telegram t.me/vvtopo','Telegram t.me/ochkuryvl','Статьи VL.ru','Википедия','Wikimapia','Другие сайты','vvmap (первоисточник не указан)']
for o in out:
    g=set(); yd=o['yd'].lower()
    for i in o.get('src',[]):
        c=SRCS[i]
        if c[0] in 'dp': g.add(0)
        elif c.startswith('t:vvtopo/'): g.add(3)
        elif c.startswith('t:ochkuryvl/'): g.add(4)
        elif c.startswith('t:'): g.add(8)
        elif 'wikipedia.org' in c or 'ruwiki.ru' in c: g.add(6)
        elif 'wikimapia.org' in c: g.add(7)
        elif 'newsvl.ru' in c: g.add(5)
        else: g.add(8)
    if '1924' in yd and 'справоч' in yd: g.add(1)
    if 'спис' in yd and ('1954' in yd or '1957' in yd): g.add(2)
    if o.get('a'): g.add(5)
    if VV_SRC.get(_vk(o['n']),'').lower()=='wikimapia': g.add(7)
    if not g: g.add(9)
    o['sg']=sorted(g)
print('source groups:',{SG[k]:sum(1 for o in out if k in o['sg']) for k in range(len(SG))})
print('article notes: lines',sum(1 for o in out if o.get('a')),'articles',len(ARTS))
json.dump(dict(f=out,capes=cp,places=PL,srcs=SRCS,sg=SG,arts=ARTS,names_total=names_total,names_unique=names_unique,houses=houses_seg,water=water_seg),open(OUT,'w',encoding='utf-8'),ensure_ascii=False,separators=(',',':'))
print(os.path.getsize(OUT))
print(collections.Counter(o['g'] for o in out)); print(sum(1 for o in out if o['y'] is None))
