# V15: сегмент «вода» для карты — береговая линия OSM вокруг Владивостока.
# Источник: 02_data/osm_coastline_raw.json (ответ Overpass, natural=coastline; файл коммитится,
# сеть при пересборке не нужна). fiord.json из vvmap — это MapLibre-стиль «Fiord Color»,
# полигонов воды там нет, поэтому вода берётся напрямую из OSM (запасной пункт карточки V15).
# Выход: 05_code/water.json = {"d": "<SVG path, fill-rule=evenodd>", "rect": [x0,y0,x1,y1]}
#   подпути: прямоугольник покрытия + контуры СУШИ; нечётная глубина вложенности = вода.
# Запуск: python3 05_code/water_prep.py (cwd не важен).
import json,math,os,collections

HERE=os.path.dirname(os.path.abspath(__file__))
DATA_DIR=os.path.join(HERE,'..','02_data')

# --- та же проекция, что в prep.py (units = 10 м)
lat0=43.11; kx=math.cos(math.radians(lat0))*111320; ky=110574
lon0,latT=131.70,43.32
def proj(c): return ((c[0]-lon0)*kx/10.0,(latT-c[1])*ky/10.0)

# --- прямоугольник покрытия карты (FULL из шаблона) + запас по краям
FULL={'x':60,'y':40,'w':4200,'h':4440}
MARGIN=650
def rect(m):
    return (FULL['x']-m, FULL['y']-m, FULL['x']+FULL['w']+m, FULL['y']+FULL['h']+m)

# --- 1. цепочки береговой линии: склейка OSM-way'ов по id узлов (в Overpass-ответе
# у каждого way есть nodes + geometry); направление отдельных way'ов произвольно.
def load_chains():
    d=json.load(open(os.path.join(DATA_DIR,'osm_coastline_raw.json'),encoding='utf-8'))
    ways=[]
    for e in d['elements']:
        if e.get('type')!='way' or not e.get('nodes'): continue
        geo=e.get('geometry') or []
        if len(geo)<2: continue
        ways.append((e['nodes'],[(p['lon'],p['lat']) for p in geo]))  # (lon,lat), как в geojson
    nxt=collections.defaultdict(list)  # node_id -> [(way_idx, pos)] , pos 0|last
    for i,(nodes,_) in enumerate(ways):
        nxt[nodes[0]].append((i,0)); nxt[nodes[-1]].append((i,1))
    used=set(); chains=[]
    def walk(i):
        # максимальная цепочка через way i: пристыковываем соседей и вперёд, и назад
        nodes,coords=ways[i]
        seq=nodes[:]; cs=coords[:]; used.add(i)
        for direction in (1,0):
            while True:
                end = seq[-1] if direction==1 else seq[0]
                cand=[(j,p) for j,p in nxt[end] if j not in used]
                if len(cand)!=1: break
                j,p=cand[0]
                jn,jc=ways[j]
                if direction==1:
                    # стык в начале j (p==0) -> j как есть; в конце j (p==1) -> реверс
                    addn=jn if p==0 else list(reversed(jn))
                    addc=jc if p==0 else list(reversed(jc))
                    seq.extend(addn[1:]); cs.extend(addc[1:]); used.add(j)
                else:
                    # прицепляем ПЕРЕД началом: идём по j от дальнего конца к стыку
                    pre_n=jn[:-1] if p==1 else list(reversed(jn))[:-1]
                    pre_c=jc[:-1] if p==1 else list(reversed(jc))[:-1]
                    seq[:0]=pre_n; cs[:0]=pre_c; used.add(j)
        return cs
    for i in range(len(ways)):
        if i in used: continue
        cs=walk(i)
        if len(cs)>=2: chains.append(cs)
    return chains

def to_xy(chain): return [proj(c) for c in chain]

# замкнутую цепочку поворачиваем так, чтобы она начиналась ВНЕ прямоугольника:
# иначе клип режет внутреннюю дугу на две части в произвольной стартовой вершине
def rotate_closed_out(ch,R):
    if ch[0]!=ch[-1]: return ch
    x0,y0,x1,y1=R
    out=lambda p: p[0]<x0 or p[0]>x1 or p[1]<y0 or p[1]>y1
    for i,p in enumerate(ch):
        if out(p) and i<len(ch)-1:
            return ch[i:-1]+ch[:i]+[ch[i]]
    return ch

# --- 2. клип полилинии по прямоугольнику (концы ровно на границе)
def clip_polyline(pts,R):
    x0,y0,x1,y1=R
    def inside(p): return x0<=p[0]<=x1 and y0<=p[1]<=y1
    edges=((x0,y0,x0,y1),(x1,y0,x1,y1),(x0,y0,x1,y0),(x0,y1,x1,y1))
    out=[]; cur=None
    def emit(p):
        nonlocal cur
        p=(int(round(p[0])),int(round(p[1])))
        if cur is None: cur=[p]
        elif p!=cur[-1]: cur.append(p)
    n=len(pts)
    for i in range(n-1):
        p,q=pts[i],pts[i+1]
        pin,qin=inside(p),inside(q)
        if pin: emit(p)
        if pin==qin: continue
        best=None
        for (ax,ay,bx,by) in edges:
            dx=q[0]-p[0]; dy=q[1]-p[1]
            if dx!=0:
                t=(ax-p[0])/dx
                if 0<=t<=1:
                    y=p[1]+t*dy
                    if min(ay,by)-1e-9<=y<=max(ay,by)+1e-9 and (best is None or t<best[0]): best=(t,(ax,y))
            if dy!=0:
                t=(ay-p[1])/dy
                if 0<=t<=1:
                    x=p[0]+t*dx
                    if min(ax,bx)-1e-9<=x<=max(ax,bx)+1e-9 and (best is None or t<best[0]): best=(t,(x,ay))
        if best is None: continue
        if pin:  # выходим наружу
            emit(best[1])
            if len(cur)>=2: out.append(cur)
            cur=None
        else:    # входим снаружи
            emit(best[1])
    if inside(pts[-1]): emit(pts[-1])
    if cur is not None and len(cur)>=2: out.append(cur)
    return out

# --- 3. Дуглас–Пюкер с адаптивным eps: детально рядом с картой (FULL+PAD),
# грубо вдали — берег вдали не влияет на вид улиц.
PAD=700
def in_core(p):
    R=rect(PAD)
    return R[0]<=p[0]<=R[2] and R[1]<=p[1]<=R[3]
def dp(pts):
    def eps_at(p): return 1.1 if in_core(p) else 4.0
    def rec(a):
        if len(a)<3: return a[:]
        s,e=a[0],a[-1]; dx,dy=e[0]-s[0],e[1]-s[1]; L=math.hypot(dx,dy)
        i,dm=0,0.0
        for k in range(1,len(a)-1):
            p=a[k]
            if L<1e-6:  # замкнутое кольцо: хорда вырождена — расстояние до точки
                d=math.hypot(p[0]-s[0],p[1]-s[1])
            else:
                d=abs(dy*p[0]-dx*p[1]+e[0]*s[1]-e[1]*s[0])/L
            if d>dm: i,dm=k,d
        eps=lambda p: 2.0 if in_core(p) else 8.0
        if dm>max(eps(a[i]),min(eps(s),eps(e))):
            return rec(a[:i+1])[:-1]+rec(a[i:])
        return [s,e]
    return rec(pts)

# --- 4. точка в полигоне (ray casting) и площадь кольца
def pip(pt,ring):
    x,y=pt; n=len(ring); inside=False
    for i in range(n):
        x1,y1=ring[i]; x2,y2=ring[(i+1)%n]
        if (y1>y)!=(y2>y):
            xin=x1+(y-y1)*(x2-x1)/(y2-y1)
            if xin>x: inside=not inside
    return inside
def ring_area(r):
    s=0.0
    for i in range(len(r)):
        x1,y1=r[i]; x2,y2=r[(i+1)%len(r)]
        s+=x1*y2-x2*y1
    return s/2

# --- 5. замыкание цепочки дугой периметра прямоугольника
def border_path(R,p,q):
    # по периметру против часовой стрелки от p к q:
    # низ (x0,y0)->(x1,y0), право (x1,y0)->(x1,y1), верх (x1,y1)->(x0,y1), лево (x0,y1)->(x0,y0)
    x0,y0,x1,y1=R; W=x1-x0; H=y1-y0; P=2*(W+H)
    def perim(pt):
        x,y=pt
        if abs(y-y0)<1e-6: return x-x0
        if abs(x-x1)<1e-6: return W+(y-y0)
        if abs(y-y1)<1e-6: return W+H+(x1-x)
        return 2*W+H+(y1-y)
    pp,pq=perim(p),perim(q); P=2*(W+H)
    pts=[p]
    if (pq-pp)%P:
        for c in ((x0,y0),(x1,y0),(x1,y1),(x0,y1)):
            if ((perim(c)-pp)%P) < ((pq-pp)%P): pts.append(c)
    pts.append(q)
    out=[pts[0]]
    for t in pts[1:]:
        if t!=out[-1]: out.append(t)
    return out
def close_ring(R,pts,ccw):
    # кольцо = ломаная (p..q на границе) + дуга периметра от q к p;
    # ccw=True — дуга против часовой (border_path(q->p)), иначе — вторая дуга (разворот p->q)
    p,q=pts[0],pts[-1]
    if ccw: arc=border_path(R,q,p)
    else:   arc=border_path(R,p,q)[::-1]
    ring=pts[:]+arc[1:]
    if len(ring)>2 and ring[0]==ring[-1]: ring=ring[:-1]
    return ring

# --- 6. пробы: суша = вершины улиц + мысы; вода = середины заливов/проливов
def load_probes():
    fs=json.load(open(os.path.join(DATA_DIR,'streets_map.geojson'),encoding='utf-8'))['features']
    land=[]
    for f in fs:
        g=f['geometry']; ln=g['coordinates'] if g['type']=='MultiLineString' else [g['coordinates']]
        for l in ln:
            for c in l[::7]: land.append(proj(c))
    capes=json.load(open(os.path.join(DATA_DIR,'vvmap_capes.geojson'),encoding='utf-8'))['features']
    for c in capes: land.append(proj(c['geometry']['coordinates']))
    water=[proj(c) for c in [(131.80,43.03),(132.12,43.03),(131.94,43.06),(131.95,42.85),(131.80,42.75)]]  # (lon,lat)
    return land,water

def main():
    chains=[to_xy(c) for c in load_chains()]
    print('chains',len(chains))
    landp,waterp=load_probes()
    # подбор запаса: ровно один открытый кусок (материк) с концами на границе,
    # острова — целиком внутри. Прямоугольник зажимаем в bbox выгрузки с отступом,
    # иначе на больших m он вылезает за пределы скачанных данных.
    FETCH=(42.60,131.30,43.60,132.60)  # (юг, запад, север, восток)
    wx0=proj((FETCH[1],FETCH[0]))[0]; wx1=proj((FETCH[3],FETCH[0]))[0]
    wy0=proj((FETCH[1],FETCH[2]))[1]; wy1=proj((FETCH[1],FETCH[0]))[1]
    def clamp(Rc,pad=200):
        return (max(Rc[0],round(wx0)+pad), max(Rc[1],round(wy0)+pad),
                min(Rc[2],round(wx1)-pad), min(Rc[3],round(wy1)-pad))
    R=None; pieces=None
    for m in (650,1500,2500,4000,6000,9000):
        Rc=clamp(rect(m))
        pcs=[]
        for ch in chains:
            ch2=rotate_closed_out(ch,Rc)
            pcs.extend(clip_polyline(ch2,Rc))
        openpcs=[p for p in pcs if p[0]!=p[-1]]
        closedpcs=[p for p in pcs if p[0]==p[-1]]
        onb=lambda pt: pt[0]<=Rc[0] or pt[0]>=Rc[2] or pt[1]<=Rc[1] or pt[1]>=Rc[3]
        okopen = len(openpcs)==1 and all(onb(t) for t in (openpcs[0][0],openpcs[0][-1])) if openpcs else False
        print('m=%d: rect=%s pieces=%d open=%d closed=%d ok=%s'%(m,Rc,len(pcs),len(openpcs),len(closedpcs),okopen))
        R=Rc; pieces=pcs
        if okopen: break
    if pieces is None:
        raise SystemExit('не удалось подобрать прямоугольник')
    print('rect',R)
    rings=[]; nopen=0
    for pc in pieces:
        s=dp(pc)
        if len(s)<3: continue
        p,q=s[0],s[-1]
        closed = p==q
        onborder = lambda pt: pt[0]<=R[0] or pt[0]>=R[2] or pt[1]<=R[1] or pt[1]>=R[3]
        if closed:
            rings.append(s[:-1])
        elif onborder(p) and onborder(q):
            r1=close_ring(R,s,True); r2=close_ring(R,s,False)
            ok=lambda ring: not any(pip(w,ring) for w in waterp)
            r=r1 if ok(r1) else (r2 if ok(r2) else None)
            if r is None:
                print('WARN: обе дуги содержат воду, кусок пропущен, len',len(s))
                continue
            rings.append(r); nopen+=1
        else:
            print('WARN: кусок не на границе и не замкнут, len',len(s),'ends',p,q)
    print('rings',len(rings),'замкнутых через границу:',nopen)
    # все кольца включаем: чётность evenodd (прямоугольник + кольца) сама даёт
    # воду на нечётной глубине вложенности (залив -> остров -> озеро). Контроль:
    nw=sum(1 for r in rings if any(pip(w,r) for w in waterp))
    print('колец с водными пробами внутри (санити):',nw)
    kept=rings[:]
    x0,y0,x1,y1=R
    def rel(ring):
        out=['M%d %d'%ring[0]]
        px,py=ring[0]
        for p in ring[1:]:
            out.append('l%d %d'%(p[0]-px,p[1]-py)); px,py=p
        return ''.join(out)+'Z'
    parts=[rel([(x0,y0),(x1,y0),(x1,y1),(x0,y1),(x0,y0)])]
    for r in kept:
        parts.append(rel(r+[r[0]]))
    dstr=''.join(parts)
    # --- самопроверка: чётность (прямоугольник + кольца) — 0 = суша, 1 = вода
    def parity(pt):
        n=1 if pip(pt,[(x0,y0),(x1,y0),(x1,y1),(x0,y1)]) else 0
        for r in kept:
            if pip(pt,r): n^=1
        return n
    badland=[p for p in landp if parity(p)!=0]
    badwater=[p for p in waterp if parity(p)!=1]
    print('нарушения: уличные/мысовые пробы на воде:',len(badland),'; водные пробы на суше:',len(badwater))
    if badland[:5]: print('  примеры:',badland[:5])
    json.dump({'d':dstr,'rect':list(R)},open(os.path.join(HERE,'water.json'),'w',encoding='utf-8'),separators=(',',':'))
    print('water path chars',len(dstr),'->',os.path.getsize(os.path.join(HERE,'water.json')),'bytes')

if __name__=='__main__':
    main()
