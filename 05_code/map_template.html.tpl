<!doctype html>
<html lang="ru">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>Улицы Владивостока: о ком и о чём</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Golos+Text:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{
  --paper:#e7edf0; --panel:#f6f8f9; --ink:#14232d; --ink-2:#4b5b66; --line:#c9d3d9;
  --street:#9aa8b1; --street-dim:#cdd6db; --halo:#ffffff; --plate:#1b4d8c; --plate-ink:#ffffff;
  --g0:#d64545; --g1:#1f7fa0; --g2:#3f8f3a; --g3:#d18b17; --g4:#7a63b8; --g5:#8e2b4c; --g6:#7e8a91;
  --focus:#1b4d8c; color-scheme:light;
  box-sizing:border-box; padding-top:env(safe-area-inset-top,0px); padding-bottom:env(safe-area-inset-bottom,0px);
}
@media (prefers-color-scheme:dark){ :root:not([data-theme="light"]){
  --paper:#0f1d27; --panel:#142632; --ink:#e4ecf0; --ink-2:#9db0bb; --line:#26404f;
  --street:#4c6575; --street-dim:#22394a; --halo:#0f1d27; --plate:#2a64ad; --plate-ink:#ffffff;
  --g0:#f06a5f; --g1:#47b3d6; --g2:#6cbf5f; --g3:#f0b142; --g4:#a28ee0; --g5:#d0668c; --g6:#93a1a9;
  --focus:#7fb2ff; color-scheme:dark; }}
:root[data-theme="dark"]{
  --paper:#0f1d27; --panel:#142632; --ink:#e4ecf0; --ink-2:#9db0bb; --line:#26404f;
  --street:#4c6575; --street-dim:#22394a; --halo:#0f1d27; --plate:#2a64ad; --plate-ink:#ffffff;
  --g0:#f06a5f; --g1:#47b3d6; --g2:#6cbf5f; --g3:#f0b142; --g4:#a28ee0; --g5:#d0668c; --g6:#93a1a9;
  --focus:#7fb2ff; color-scheme:dark; }
*,*::before,*::after{box-sizing:border-box}
html{height:100%;scroll-padding-top:env(safe-area-inset-top,0px)}
body{height:100%;margin:0;background:var(--paper);color:var(--ink);font-family:"Golos Text",system-ui,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;font-size:15px;line-height:1.45}
button{font:inherit;color:inherit}
button:focus-visible,input:focus-visible,.bar:focus-visible{outline:2px solid var(--focus);outline-offset:2px}
.app{height:100%;display:grid;grid-template-columns:minmax(0,1fr) 360px;grid-template-rows:minmax(0,1fr) auto}
.mapwrap{position:relative;grid-column:1;grid-row:1;overflow:hidden;touch-action:none;cursor:grab}
.mapwrap.drag{cursor:grabbing}
svg#map{width:100%;height:100%;display:block}
.s{fill:none;stroke:var(--street);stroke-width:1.15;vector-effect:non-scaling-stroke;stroke-linecap:round;stroke-linejoin:round;transition:stroke .12s,opacity .12s}
.g0{stroke:var(--g0)}.g1{stroke:var(--g1)}.g2{stroke:var(--g2)}.g3{stroke:var(--g3)}.g4{stroke:var(--g4)}.g5{stroke:var(--g5)}.g6{stroke:var(--g6)}
#streets .s{opacity:.72}
.focus #streets .s{stroke:var(--street-dim);opacity:1}
.focus #streets .s.hl{stroke-width:2.3;opacity:1}
.focus #streets .s.hl.g0{stroke:var(--g0)}.focus #streets .s.hl.g1{stroke:var(--g1)}.focus #streets .s.hl.g2{stroke:var(--g2)}.focus #streets .s.hl.g3{stroke:var(--g3)}.focus #streets .s.hl.g4{stroke:var(--g4)}.focus #streets .s.hl.g5{stroke:var(--g5)}.focus #streets .s.hl.g6{stroke:var(--g6)}
.cumul #streets .s.future{opacity:0}
.cumul #streets .s.fresh{stroke-width:2.6}
#top .halo{fill:none;stroke:var(--halo);stroke-width:9;vector-effect:non-scaling-stroke;stroke-linecap:round;stroke-linejoin:round}
#top .core{fill:none;stroke:var(--ink);stroke-width:4;vector-effect:non-scaling-stroke;stroke-linecap:round;stroke-linejoin:round}
#hit path{fill:none;stroke:transparent;stroke-width:11;vector-effect:non-scaling-stroke;pointer-events:stroke;cursor:pointer}
.cape circle{fill:var(--ink-2)}
.cape text{fill:var(--ink-2);font-size:11px;paint-order:stroke;stroke:var(--paper);stroke-width:3px;stroke-linejoin:round}
.capes-off .cape text{display:none}
.tip{position:absolute;pointer-events:none;background:var(--ink);color:var(--paper);font-size:13px;font-weight:600;padding:4px 8px;border-radius:4px;white-space:nowrap;transform:translate(12px,-130%);display:none;z-index:3}
.zoom{position:absolute;right:12px;top:12px;display:flex;flex-direction:column;gap:6px;z-index:2}
.zoom button{width:36px;height:36px;border:1px solid var(--line);background:var(--panel);border-radius:6px;font-size:18px;line-height:1;cursor:pointer}
.zoom button:hover{border-color:var(--ink-2)}
.decade-stamp{position:absolute;left:16px;bottom:14px;font-weight:800;font-size:clamp(36px,7vw,72px);letter-spacing:-.02em;color:var(--ink);opacity:.18;pointer-events:none;line-height:1;z-index:1}
aside{grid-column:2;grid-row:1 / span 2;background:var(--panel);border-left:1px solid var(--line);overflow-y:auto;padding:22px 22px 28px;display:flex;flex-direction:column;gap:20px}
h1{font-size:22px;line-height:1.2;margin:0;font-weight:800;letter-spacing:-.01em}
.lede{margin:6px 0 0;color:var(--ink-2);font-size:14px}
.plate{background:var(--plate);color:var(--plate-ink);border-radius:7px;padding:5px}
.plate{flex:none}
.plate-in{border:2px solid rgba(255,255,255,.9);border-radius:4px;padding:8px 14px 10px;height:92px;display:flex;flex-direction:column;justify-content:center;overflow:hidden}
.plate .kind{font-size:13px;font-weight:500;opacity:.92;margin:0}
.plate .name{font-size:26px;font-weight:800;line-height:1.1;margin:2px 0 0;letter-spacing:-.005em;overflow-wrap:anywhere;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
.controls{display:flex;flex-direction:column;gap:16px;flex:none}
.relrow{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:8px 10px}
.rel{border:0;margin:0;padding:0;min-width:0;display:flex;flex-direction:column;gap:4px}
.rel legend{font-size:15px;font-weight:700;padding:0;margin-bottom:8px}
.rel button{display:grid;grid-template-columns:minmax(0,1fr) auto;grid-template-areas:"b i" "s s";column-gap:8px;row-gap:1px;align-content:center;height:48px;padding:0 10px;border:1px solid var(--line);border-radius:6px;background:transparent;text-align:left;cursor:pointer;font-size:13px;width:100%}
.rel button b{grid-area:b}.rel button span{grid-area:s;padding-left:15px}.rel button i{grid-area:i}
.rel button:hover{border-color:var(--ink-2)}
.rel button b{font-weight:600;white-space:nowrap}
.rel button b::before{content:"";display:inline-block;width:8px;height:8px;border-radius:50%;border:1.5px solid var(--ink-2);margin-right:7px;vertical-align:1px}
.rel button[aria-pressed="true"]{border-color:var(--ink);background:color-mix(in srgb,var(--ink) 7%,transparent)}
.rel button[aria-pressed="true"] b::before{background:var(--ink);border-color:var(--ink)}
.rel button span{color:var(--ink-2);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.rel button i{font-style:normal;font-variant-numeric:tabular-nums;color:var(--ink);font-weight:600}
.legend{display:flex !important;flex-direction:row !important;flex-wrap:wrap;gap:2px 2px !important}
.legend li{flex:none}
.legend button{width:auto !important;grid-template-columns:14px auto auto !important;padding:4px 7px !important}
.src summary{cursor:pointer;font-weight:600;color:var(--ink-2);list-style-position:inside}
.src details[open] summary{margin-bottom:8px}
.relrow span{font-size:15px;font-weight:700}
.info{flex:1 1 0;min-height:260px;overflow-y:auto;overscroll-behavior:contain;border-top:1px solid var(--line);padding-top:16px}
.src{flex:none}
.plate.empty .name{font-size:17px;font-weight:600}
.crumbs{font-size:14px;margin:10px 0 0;color:var(--ink)}
.crumbs .sw{display:inline-block;width:10px;height:10px;border-radius:2px;margin-right:6px;vertical-align:0}
.meta{font-size:14px;color:var(--ink-2);margin:6px 0 0}
.meta b{color:var(--ink);font-weight:600}
.warn{font-size:13px;color:var(--ink-2);margin:6px 0 0}
.rel-head{display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:8px 10px;margin-top:14px}
.rel-head p{margin:0;font-size:14px;font-weight:600}
.seg{display:inline-flex;border:1px solid var(--line);border-radius:6px;overflow:hidden}
.seg button{border:0;background:transparent;padding:5px 9px;font-size:13px;cursor:pointer;color:var(--ink-2)}
.seg button[aria-pressed="true"]{background:var(--ink);color:var(--paper)}
.chips{display:flex;flex-wrap:wrap;gap:5px;margin-top:10px}
.chips button{border:1px solid var(--line);background:transparent;border-radius:4px;padding:2px 7px;font-size:13px;cursor:pointer}
.chips button:hover{border-color:var(--ink-2)}
.chips .more{font-size:13px;color:var(--ink-2);padding:3px 2px}
h2{font-size:15px;margin:0 0 8px;font-weight:700}
.legend{list-style:none;margin:0;padding:0;display:flex;flex-direction:column;gap:2px}
.legend button{width:100%;display:grid;grid-template-columns:14px 1fr auto;gap:9px;align-items:center;border:0;background:transparent;padding:5px 6px;border-radius:5px;text-align:left;cursor:pointer;font-size:14px}
.legend button:hover,.legend button[aria-pressed="true"]{background:color-mix(in srgb,var(--ink) 8%,transparent)}
.legend .sw{width:14px;height:4px;border-radius:2px}
.legend .n{color:var(--ink-2);font-variant-numeric:tabular-nums}
.search input{width:100%;padding:8px 10px;border:1px solid var(--line);border-radius:6px;background:var(--paper);color:var(--ink);font:inherit;font-size:14px}
.search p{margin:6px 0 0;font-size:13px;color:var(--ink-2);min-height:1em}
.src{font-size:12.5px;color:var(--ink-2);border-top:1px solid var(--line);padding-top:14px;margin-top:auto}
.src p{margin:0 0 6px}
.src a{color:inherit}
.timeline{grid-column:1;grid-row:2;background:var(--panel);border-top:1px solid var(--line);padding:10px 14px 12px;display:grid;grid-template-columns:auto minmax(0,1fr);gap:4px 14px;align-items:end}
.tl-side{display:flex;flex-direction:column;gap:6px;align-self:stretch;justify-content:space-between;width:156px;flex:none}
#tlinfo{height:3.9em;overflow:hidden}
.tl-side p{margin:0;font-size:13px;color:var(--ink-2);line-height:1.3}
.tl-side strong{display:block;color:var(--ink);font-size:15px}
.play{border:1px solid var(--ink);background:var(--ink);color:var(--paper);border-radius:6px;padding:6px 10px;font-size:13px;font-weight:600;cursor:pointer;white-space:nowrap}
.bars{display:flex;align-items:flex-end;gap:3px;height:96px;overflow-x:auto;padding:0 10px 18px 4px;position:relative}
.bar{flex:1 0 26px;display:flex;flex-direction:column-reverse;height:100%;cursor:pointer;position:relative;border-radius:3px 3px 0 0;outline-offset:1px}
.bar .seg-g{width:100%;flex:none}
.bar .lab{position:absolute;bottom:-18px;left:0;right:0;text-align:center;font-size:11px;color:var(--ink-2);font-variant-numeric:tabular-nums}
.bar:hover,.bar.on{background:color-mix(in srgb,var(--ink) 9%,transparent)}
.bar.mark::after{content:"";position:absolute;left:-1px;right:-1px;top:0;bottom:0;border:2px solid var(--ink);border-bottom:0;border-radius:3px 3px 0 0;pointer-events:none}
.bars.dimmed .bar:not(.on):not(.past) .seg-g{opacity:.35}
@media (max-width:860px){
  .app{grid-template-columns:1fr;grid-template-rows:62vh auto auto;height:auto;min-height:100%}
  html,body{height:auto}
  .mapwrap{grid-row:1;height:62vh}
  .timeline{grid-row:2}
  aside{grid-column:1;grid-row:3;border-left:0;border-top:1px solid var(--line);overflow:visible}
  .timeline{grid-template-columns:1fr}
  .tl-side{flex-direction:row;align-items:center;width:auto}
  #tlinfo{flex:1}
  .info{order:-1;flex:none;height:340px;min-height:0;border-top:0;padding-top:0}
  .bar{flex:1 0 13px}
  .bars{gap:2px}
}
@media (prefers-reduced-motion:reduce){.s{transition:none}}
</style>
</head>
<body>
<noscript><p style="margin:0;padding:12px 16px;background:#fff3cd;color:#5c4400;font:15px system-ui,sans-serif">Карте нужен JavaScript. Откройте файл в браузере (Chrome, Firefox, Safari, Edge), а не в окне предпросмотра или почтовом клиенте.</p></noscript>
<div class="app">
  <div class="mapwrap" id="wrap">
    <svg id="map" role="img" aria-label="Карта улиц Владивостока, раскрашенная по тематикам названий">
      <g id="capes"></g><g id="streets"></g><g id="top"></g><g id="hit"></g>
    </svg>
    <div class="zoom">
      <button id="zin" aria-label="Приблизить">+</button>
      <button id="zout" aria-label="Отдалить">−</button>
      <button id="zreset" aria-label="Показать весь город">⤢</button>
    </div>
    <div class="decade-stamp" id="stamp" aria-hidden="true"></div>
    <div class="tip" id="tip"></div>
  </div>

  <section class="timeline" aria-label="Годы присвоения названий">
    <div class="tl-side">
      <p id="tlinfo"><strong>Годы названий</strong>Наведите или нажмите на десятилетие</p>
      <button class="play" id="play">▶ Показать рост</button>
    </div>
    <div class="bars" id="bars"></div>
  </section>

  <aside>
    <header>
      <h1>Улицы Владивостока: о ком и о чём</h1>
    </header>

    <div class="controls">
      <section class="search">
        <h2><label for="q">Найти улицу</label></h2>
        <input id="q" list="names" placeholder="Например, Светланская" autocomplete="off">
        <datalist id="names"></datalist>
        <p id="qmsg"></p>
      </section>

      <fieldset class="rel" id="relseg">
        <legend>Что подсвечивать вместе с улицей</legend>
        <button data-m="sub" aria-pressed="false"><b>Та же подтема</b><span id="rv-sub"></span><i id="rn-sub"></i></button>
        <button data-m="cat" aria-pressed="true"><b>Та же тематика</b><span id="rv-cat"></span><i id="rn-cat"></i></button>
        <button data-m="group" aria-pressed="false"><b>Та же группа</b><span id="rv-group"></span><i id="rn-group"></i></button>
      </fieldset>

      <section>
        <h2>Группы названий</h2>
        <ul class="legend" id="legend"></ul>
      </section>
    </div>

    <section class="info" aria-live="polite">
      <div class="plate empty" id="plate"><div class="plate-in"><p class="kind" id="pkind">Владивосток</p><p class="name" id="pname">Выберите улицу на карте</p></div></div>
      <div id="details"></div>
    </section>

    <footer class="src"><details><summary>Источники и пояснения</summary>
      <p>Геометрия улиц — © участники OpenStreetMap (ODbL), выгрузка и годы названий — открытый проект <a href="https://github.com/skirienko/vvmap" target="_blank" rel="noopener">vvmap</a>.</p>
      <p>Год — когда улица получила нынешнее название или впервые упомянута в документах. Пик 1920-х во многом даёт справочник 1924 года.</p>
      <p>Тематическая классификация — составлена в нашем разговоре; около 10% названий помечены как требующие проверки.</p>
    </details></footer>
  </aside>
</div>

<script>
const DATA = __DATA__;
const GROUPS=['Персоналии','География','Природа','Тематические (нарицательные)','Описательные и ориентирующие','События и символика','Прочее / неясно'];
const GSHORT=['Персоналии','География','Природа','Тематические','Описательные','События и символика','Прочее'];
const F=DATA.f, NS='http://www.w3.org/2000/svg';
const svg=document.getElementById('map'), wrap=document.getElementById('wrap');
const gStreets=document.getElementById('streets'), gHit=document.getElementById('hit'), gTop=document.getElementById('top'), gCapes=document.getElementById('capes');
const tip=document.getElementById('tip');
let relMode='cat';

// ---------- indexes
const byKey={group:{},cat:{},sub:{}}, byName={}, byDec={};
const D0=1860, D1=2020;
F.forEach((f,i)=>{
  f.gi=GROUPS.indexOf(f.g);
  const k={group:f.g,cat:f.g+'|'+f.c,sub:f.g+'|'+f.c+'|'+f.s};
  for(const m in k)(byKey[m][k[m]]=byKey[m][k[m]]||[]).push(i);
  (byName[f.n]=byName[f.n]||[]).push(i);
  if(f.y!=null){const d=Math.max(D0,Math.min(D1,Math.floor(f.y/10)*10));f.dec=d;(byDec[d]=byDec[d]||[]).push(i);}
});
const keyOf=(f,m)=>m==='group'?f.g:m==='cat'?f.g+'|'+f.c:f.g+'|'+f.c+'|'+f.s;

// ---------- draw
const paths=[], hits=[];
F.forEach((f,i)=>{
  const p=document.createElementNS(NS,'path');p.setAttribute('d',f.d);p.setAttribute('class','s g'+f.gi);gStreets.appendChild(p);paths.push(p);
  const h=document.createElementNS(NS,'path');h.setAttribute('d',f.d);h.dataset.i=i;gHit.appendChild(h);hits.push(h);
});
DATA.capes.forEach(([x,y,n])=>{
  const g=document.createElementNS(NS,'g');g.setAttribute('class','cape');
  const c=document.createElementNS(NS,'circle');c.setAttribute('cx',x);c.setAttribute('cy',y);c.setAttribute('r',3);c.setAttribute('vector-effect','non-scaling-stroke');
  const t=document.createElementNS(NS,'text');t.setAttribute('x',x+6);t.setAttribute('y',y+4);t.textContent=n;
  g.append(c,t);gCapes.appendChild(g);
});

// ---------- view (zoom/pan)
const FULL={x:60,y:40,w:4200,h:4440};
let view={...FULL};
function fitFull(){
  const r=wrap.getBoundingClientRect(), ar=r.width/r.height;
  // start on the central peninsula, where most streets are
  const c={x:1900,y:1950}, h=Math.max(2200,1700/ar), w=h*ar;
  view={x:c.x-w/2,y:c.y-h/2,w,h};apply();
}
function apply(){
  svg.setAttribute('viewBox',`${view.x} ${view.y} ${view.w} ${view.h}`);
  const r=wrap.getBoundingClientRect(), scale=r.width/view.w; // px per unit
  // cape radius & label size constant in px
  gCapes.querySelectorAll('circle').forEach(c=>c.setAttribute('r',2.2/scale));
  gCapes.querySelectorAll('text').forEach(t=>{t.style.fontSize=(11/scale)+'px';t.style.strokeWidth=(3/scale)+'px';});
  svg.classList.toggle('capes-off',scale<0.55);
}
function toSvg(px,py){const r=wrap.getBoundingClientRect();return{x:view.x+(px-r.left)/r.width*view.w,y:view.y+(py-r.top)/r.height*view.h};}
function zoomAt(k,px,py){
  const r=wrap.getBoundingClientRect(); if(px==null){px=r.left+r.width/2;py=r.top+r.height/2;}
  const p=toSvg(px,py); let nw=view.w*k;
  nw=Math.max(120,Math.min(9000,nw)); k=nw/view.w;
  view={x:p.x-(p.x-view.x)*k,y:p.y-(p.y-view.y)*k,w:view.w*k,h:view.h*k};apply();
}
wrap.addEventListener('wheel',e=>{e.preventDefault();zoomAt(Math.exp(e.deltaY*(e.deltaMode?0.05:0.0015)),e.clientX,e.clientY);},{passive:false});
document.getElementById('zin').onclick=()=>zoomAt(0.6);
document.getElementById('zout').onclick=()=>zoomAt(1/0.6);
document.getElementById('zreset').onclick=()=>fitFull();
const ptrs=new Map(); let dragStart=null, moved=false, pinch=null;
wrap.addEventListener('pointerdown',e=>{
  if(e.target.closest('.zoom'))return;
  ptrs.set(e.pointerId,{x:e.clientX,y:e.clientY});
  if(ptrs.size===1){dragStart={x:e.clientX,y:e.clientY,v:{...view}};moved=false;}
  if(ptrs.size===2){const [a,b]=[...ptrs.values()];pinch={d:Math.hypot(a.x-b.x,a.y-b.y),v:{...view},c:toSvg((a.x+b.x)/2,(a.y+b.y)/2)};moved=true;}
});
wrap.addEventListener('pointermove',e=>{
  if(!ptrs.has(e.pointerId))return;
  ptrs.set(e.pointerId,{x:e.clientX,y:e.clientY});
  const r=wrap.getBoundingClientRect();
  if(ptrs.size===2&&pinch){
    const [a,b]=[...ptrs.values()], d=Math.hypot(a.x-b.x,a.y-b.y)||1, k=pinch.d/d;
    const w=Math.max(120,Math.min(9000,pinch.v.w*k)), kk=w/pinch.v.w;
    view={x:pinch.c.x-(pinch.c.x-pinch.v.x)*kk,y:pinch.c.y-(pinch.c.y-pinch.v.y)*kk,w:pinch.v.w*kk,h:pinch.v.h*kk};apply();return;
  }
  if(dragStart){
    const dx=e.clientX-dragStart.x, dy=e.clientY-dragStart.y;
    if(!moved&&Math.hypot(dx,dy)>5){moved=true;wrap.classList.add('drag');try{wrap.setPointerCapture(e.pointerId)}catch(_){} hideTip();}
    if(moved){view={...dragStart.v,x:dragStart.v.x-dx/r.width*view.w,y:dragStart.v.y-dy/r.height*view.h};apply();}
  }
});
function endPtr(e){
  const wasTap=ptrs.size===1&&!moved;
  ptrs.delete(e.pointerId); if(ptrs.size<2)pinch=null;
  if(ptrs.size===0){wrap.classList.remove('drag');dragStart=null;}
  if(wasTap&&e.type==='pointerup'){
    const t=document.elementFromPoint(e.clientX,e.clientY);
    if(t&&t.parentNode===gHit){select(+t.dataset.i,false);} else if(!e.target.closest('.zoom')) clearPin();
  }
}
wrap.addEventListener('pointerup',endPtr);wrap.addEventListener('pointercancel',endPtr);

// ---------- highlight state
let pinned=null;           // index of pinned street
let hlSet=[], mainSet=[];
let tlState=null;          // {dec} hovered decade
function clearHL(){hlSet.forEach(i=>paths[i].classList.remove('hl'));hlSet=[];gTop.textContent='';svg.classList.remove('focus');}
function drawMain(ids){
  gTop.textContent='';
  ids.forEach(i=>{for(const cls of ['halo','core']){const p=document.createElementNS(NS,'path');p.setAttribute('d',F[i].d);p.setAttribute('class',cls);gTop.appendChild(p);}});
}
function related(i){return byKey[relMode][keyOf(F[i],relMode)]||[];}
function showStreet(i){
  updRel(i);
  clearCumul(); clearHL();
  const rel=related(i); hlSet=rel.slice(); rel.forEach(j=>paths[j].classList.add('hl'));
  const same=byName[F[i].n]; drawMain(same);
  svg.classList.add('focus'); markDecade(F[i].dec); renderDetails(i,rel);
}
function showSet(ids,mainIds){
  updRel(null);
  clearCumul(); clearHL(); hlSet=ids.slice(); ids.forEach(j=>paths[j].classList.add('hl')); svg.classList.add('focus'); drawMain(mainIds||[]);
}
function restore(){
  if(pinned!=null) showStreet(pinned);
  else if(legendPinned!=null) showGroup(legendPinned);
  else if(decPinned!=null) showDecade(decPinned);
  else {clearHL();markDecade(null);renderEmpty();}
}
function select(i,zoom){
  pinned=i; legendPinned=null; decPinned=null; syncPressed(); showStreet(i);
  if(zoom){const bb=paths[i].getBBox(), r=wrap.getBoundingClientRect(), ar=r.width/r.height;
    let h=Math.max(bb.height*2.4,bb.width*2.4/ar,500), w=h*ar; view={x:bb.x+bb.width/2-w/2,y:bb.y+bb.height/2-h/2,w,h};apply();}
}
function clearPin(){pinned=null;legendPinned=null;decPinned=null;syncPressed();restore();}
function fitTo(ids){if(!ids.length)return;let x0=1e9,y0=1e9,x1=-1e9,y1=-1e9;ids.forEach(i=>{const b=paths[i].getBBox();x0=Math.min(x0,b.x);y0=Math.min(y0,b.y);x1=Math.max(x1,b.x+b.width);y1=Math.max(y1,b.y+b.height);});
  const r=wrap.getBoundingClientRect(),ar=r.width/r.height,pad=1.12;const w=Math.max((x1-x0)*pad,(y1-y0)*pad*ar,600*ar),h=w/ar;view={x:(x0+x1)/2-w/2,y:(y0+y1)/2-h/2,w,h};apply();}
function frameNote(ids){let k=0;ids.forEach(i=>{const b=paths[i].getBBox();if(b.x+b.width>=view.x&&b.x<=view.x+view.w&&b.y+b.height>=view.y&&b.y<=view.y+view.h)k++;});
  return k<ids.length?`<p class="meta">В кадре видно <b>${k}</b> из ${ids.length}, остальные за краем карты. Нажмите на столбик, чтобы показать все.</p>`:'';}

// hover on map
gHit.addEventListener('pointerover',e=>{if(moved&&dragStart)return;const i=+e.target.dataset.i;if(e.pointerType!=='touch'){showStreet(i);showTip(e,F[i].n);}});
gHit.addEventListener('pointermove',e=>{if(e.pointerType!=='touch'&&!(moved&&dragStart))showTip(e,F[+e.target.dataset.i].n);});
gHit.addEventListener('pointerout',e=>{if(e.pointerType==='touch')return;hideTip();restore();});
function showTip(e,t){const r=wrap.getBoundingClientRect();tip.textContent=t;tip.style.left=(e.clientX-r.left)+'px';tip.style.top=(e.clientY-r.top)+'px';tip.style.display='block';}
function hideTip(){tip.style.display='none';}
document.addEventListener('keydown',e=>{if(e.key==='Escape'){clearPin();}});

// ---------- details panel
const plate=document.getElementById('plate'), pkind=document.getElementById('pkind'), pname=document.getElementById('pname'), details=document.getElementById('details');
const KINDS=['улица','переулок','проспект','шоссе','набережная','бульвар','площадь','проезд'];
function splitName(n){
  const w=n.split(' '); let kind='',rest=[];
  w.forEach(t=>{if(!kind&&KINDS.includes(t.toLowerCase()))kind=t.toLowerCase();else rest.push(t);});
  return {kind:kind||'',name:rest.join(' ')||n};
}
const esc=s=>String(s).replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
const relLabel={cat:'тематики',sub:'подтемы',group:'группы'};
function updRel(i){
  const G={sub:'узко: одна эпоха, регион или вид',cat:'средне: род занятий или тип объекта',group:'широко: люди, география, природа…'};
  ['sub','cat','group'].forEach(m=>{
    const v=document.getElementById('rv-'+m), n=document.getElementById('rn-'+m);
    if(i==null){v.textContent=G[m];v.title='';n.textContent='';return;}
    const f=F[i], val=m==='sub'?f.s:m==='cat'?f.c:f.g; v.textContent=val; v.title=val;
    const s=new Set((byKey[m][keyOf(f,m)]||[]).map(j=>F[j].n)); s.delete(f.n); n.textContent=s.size;
  });
}
function plural(n,a,b,c){n=Math.abs(n)%100;const m=n%10;if(n>10&&n<20)return c;if(m>1&&m<5)return b;if(m===1)return a;return c;}
function renderDetails(i,rel){
  const f=F[i], sp=splitName(f.n);
  plate.classList.remove('empty'); pkind.textContent=sp.kind||'улица'; pname.textContent=sp.name;
  const names=[...new Set(rel.map(j=>F[j].n))].filter(n=>n!==f.n).sort((a,b)=>splitName(a).name.localeCompare(splitName(b).name,'ru'));
  const shown=names.slice(0,16);
  const yr=f.y!=null?`<b>${f.y}</b>${f.yd?' — '+esc(f.yd):''}`:'год неизвестен';
  details.innerHTML=`
    <p class="crumbs"><span class="sw" style="background:var(--g${f.gi})"></span>${esc(f.g)} › ${esc(f.c)} › ${esc(f.s)}</p>
    ${f.o?`<p class="meta">${esc(f.o)}</p>`:''}
    <p class="meta">Название: ${yr}</p>
    ${f.u?'<p class="warn">Тематика определена предположительно, нужна проверка.</p>':''}
    <div class="rel-head"><p>${names.length} ${plural(names.length,'улица','улицы','улиц')} той же ${relLabel[relMode]}</p></div>
    <div class="chips">${shown.map(n=>`<button data-n="${esc(n)}">${esc(splitName(n).name)}</button>`).join('')}${names.length>shown.length?`<span class="more">и ещё ${names.length-shown.length}</span>`:''}</div>`;
}
function renderEmpty(){
  updRel(null);
  plate.classList.add('empty');pkind.textContent='Владивосток';pname.textContent='Выберите улицу на карте';
  details.innerHTML=`<p class="meta">Наведите на улицу — подсветятся её «родственницы» по смыслу названия: с той же подтемой, тематикой или группой (выбор выше). Нажатие закрепляет выбор, Esc или нажатие на пустое место снимает его. Цвет линии — группа названия.</p>`;
}
document.getElementById('relseg').addEventListener('click',e=>{
  const m=e.target.closest('[data-m]'); if(!m)return; relMode=m.dataset.m;
  document.querySelectorAll('#relseg [data-m]').forEach(b=>b.setAttribute('aria-pressed',String(b.dataset.m===relMode)));
  if(pinned!=null)showStreet(pinned);
});
details.addEventListener('click',e=>{
  const c=e.target.closest('[data-n]'); if(c){select(byName[c.dataset.n][0],true);}
});
let curHover=null; gHit.addEventListener('pointerover',e=>{curHover=+e.target.dataset.i});

// ---------- legend
const legend=document.getElementById('legend'); let legendPinned=null;
GROUPS.forEach((g,gi)=>{
  const li=document.createElement('li'), n=(byKey.group[g]||[]).length;
  li.innerHTML=`<button data-g="${gi}" aria-pressed="false"><span class="sw" style="background:var(--g${gi})"></span><span>${esc(GSHORT[gi])}</span><span class="n">${n}</span></button>`;
  legend.appendChild(li);
});
function showGroup(gi){showSet(byKey.group[GROUPS[gi]]||[]);markDecade(null);
  plate.classList.add('empty');pkind.textContent='группа';pname.textContent=GROUPS[gi];
  const cats={};(byKey.group[GROUPS[gi]]||[]).forEach(j=>{cats[F[j].c]=(cats[F[j].c]||0)+1;});
  details.innerHTML=`<p class="meta">${Object.entries(cats).sort((a,b)=>b[1]-a[1]).map(([c,n])=>`${esc(c)}: <b>${n}</b>`).join('<br>')}</p>`;}
legend.addEventListener('pointerover',e=>{const b=e.target.closest('[data-g]');if(b&&pinned==null)showGroup(+b.dataset.g);});
legend.addEventListener('pointerleave',()=>restore());
legend.addEventListener('click',e=>{const b=e.target.closest('[data-g]');if(!b)return;const gi=+b.dataset.g;
  if(legendPinned===gi){legendPinned=null;}else{pinned=null;decPinned=null;legendPinned=gi;fitTo(byKey.group[GROUPS[gi]]||[]);} syncPressed(); restore();});
function syncPressed(){legend.querySelectorAll('[data-g]').forEach(b=>b.setAttribute('aria-pressed',String(+b.dataset.g===legendPinned)));
  bars.querySelectorAll('.bar').forEach(b=>b.classList.toggle('on',+b.dataset.d===decPinned));}

// ---------- timeline
const bars=document.getElementById('bars'), tlinfo=document.getElementById('tlinfo'), stamp=document.getElementById('stamp');
const decs=[];for(let d=D0;d<=D1;d+=10)decs.push(d);
const maxN=Math.max(...decs.map(d=>(byDec[d]||[]).length));
decs.forEach(d=>{
  const ids=byDec[d]||[], b=document.createElement('div');b.className='bar';b.dataset.d=d;b.tabIndex=0;
  b.setAttribute('role','button');b.setAttribute('aria-label',`${d}-е: ${ids.length} ${plural(ids.length,'улица','улицы','улиц')}`);
  const cnt=GROUPS.map(()=>0);ids.forEach(i=>cnt[F[i].gi]++);
  const H=78; // px for max
  cnt.forEach((c,gi)=>{if(!c)return;const s=document.createElement('div');s.className='seg-g';s.style.height=(c/maxN*H)+'px';s.style.background=`var(--g${gi})`;b.appendChild(s);});
  const lab=document.createElement('span');lab.className='lab';lab.textContent=(d%20===0||d===D1)?String(d):'';b.appendChild(lab);
  bars.appendChild(b);
});
let decPinned=null;
function decText(d){const ids=byDec[d]||[];const cnt=GROUPS.map(()=>0);ids.forEach(i=>cnt[F[i].gi]++);
  const top=cnt.map((c,gi)=>[c,gi]).filter(x=>x[0]).sort((a,b)=>b[0]-a[0]).slice(0,2).map(([c,gi])=>`${GSHORT[gi].toLowerCase()} ${c}`).join(', ');
  return `<strong>${d}-е: ${ids.length}</strong>${top}`;}
function showDecade(d){showSet(byDec[d]||[]);markDecade(d);tlinfo.innerHTML=decText(d);
  plate.classList.add('empty');pkind.textContent='десятилетие';pname.textContent=`${d}-е годы`;
  const ids=byDec[d]||[];const names=[...new Set(ids.map(j=>F[j].n))].sort((a,b)=>(F[byName[a][0]].y-F[byName[b][0]].y));
  details.innerHTML=`<p class="meta">${ids.length} ${plural(ids.length,'улица получила','улицы получили','улиц получили')} нынешнее название в эти годы.</p>${frameNote(ids)}<div class="chips">${names.slice(0,24).map(n=>`<button data-n="${esc(n)}">${esc(splitName(n).name)} <span style="color:var(--ink-2)">${F[byName[n][0]].y}</span></button>`).join('')}${names.length>24?`<span class="more">и ещё ${names.length-24}</span>`:''}</div>`;}
function markDecade(d){bars.querySelectorAll('.bar').forEach(b=>b.classList.toggle('mark',d!=null&&+b.dataset.d===d));}
bars.addEventListener('pointerover',e=>{const b=e.target.closest('.bar');if(b&&!playing&&pinned==null)showDecade(+b.dataset.d);});
bars.addEventListener('pointerleave',()=>{if(!playing){tlinfo.innerHTML='<strong>Годы названий</strong>Наведите или нажмите на десятилетие';restore();}});
bars.addEventListener('click',e=>{const b=e.target.closest('.bar');if(!b)return;stopPlay();const d=+b.dataset.d;
  if(decPinned===d)decPinned=null;else{decPinned=d;pinned=null;legendPinned=null;fitTo(byDec[d]||[]);} syncPressed();restore();});
bars.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();e.target.click();}});
bars.addEventListener('focusin',e=>{const b=e.target.closest('.bar');if(b&&!playing)showDecade(+b.dataset.d);});

// cumulative "growth" animation
let playing=false, timer=null;
const playBtn=document.getElementById('play');
function clearCumul(){if(!svg.classList.contains('cumul'))return;svg.classList.remove('cumul');paths.forEach(p=>p.classList.remove('future','fresh'));bars.classList.remove('dimmed');bars.querySelectorAll('.bar').forEach(b=>b.classList.remove('past'));stamp.textContent='';}
function cumulTo(d){
  clearHL(); markDecade(null); svg.classList.add('cumul'); bars.classList.add('dimmed');
  F.forEach((f,i)=>{const fut=f.dec==null||f.dec>d;paths[i].classList.toggle('future',fut);paths[i].classList.toggle('fresh',f.dec===d);});
  bars.querySelectorAll('.bar').forEach(b=>{b.classList.toggle('past',+b.dataset.d<=d);b.classList.toggle('on',+b.dataset.d===d);});
  const total=F.filter(f=>f.dec!=null&&f.dec<=d).length;
  stamp.textContent=`${d}-е`; tlinfo.innerHTML=`<strong>к ${d+9} г.: ${total}</strong>новых за десятилетие: ${(byDec[d]||[]).length}`;
}
function stopPlay(){if(!playing)return;playing=false;clearInterval(timer);playBtn.textContent='▶ Показать рост';}
playBtn.onclick=()=>{
  if(playing){stopPlay();return;}
  pinned=null;legendPinned=null;decPinned=null;syncPressed();renderEmpty();
  playing=true;playBtn.textContent='❚❚ Пауза';let k=0;cumulTo(decs[k]);
  timer=setInterval(()=>{k++;if(k>=decs.length){stopPlay();setTimeout(()=>{if(!playing){clearCumul();tlinfo.innerHTML='<strong>Годы названий</strong>Наведите или нажмите на десятилетие';restore();}},1800);return;}cumulTo(decs[k]);},900);
};

// ---------- search
const dl=document.getElementById('names'), q=document.getElementById('q'), qmsg=document.getElementById('qmsg');
Object.keys(byName).sort((a,b)=>a.localeCompare(b,'ru')).forEach(n=>{const o=document.createElement('option');o.value=n;dl.appendChild(o);});
function doSearch(){
  const v=q.value.trim().toLowerCase().replace(/ё/g,'е'); if(!v){qmsg.textContent='';return;}
  const norm=s=>s.toLowerCase().replace(/ё/g,'е');
  let hit=Object.keys(byName).find(n=>norm(n)===v)||Object.keys(byName).find(n=>norm(n).includes(v));
  if(hit){qmsg.textContent='';select(byName[hit][0],true);} else qmsg.textContent='Такой улицы на карте нет. Попробуйте другое написание.';
}
q.addEventListener('change',doSearch);
q.addEventListener('keydown',e=>{if(e.key==='Enter')doSearch();});

// ---------- init
renderEmpty(); fitFull();
window.addEventListener('resize',()=>apply());
</script>
</body>
</html>
