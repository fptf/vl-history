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
  --water:#c7dcea;
  --street:#9aa8b1; --street-dim:#cdd6db; --halo:#ffffff; --plate:#1b4d8c; --plate-ink:#ffffff;
  --g0:#d64545; --g1:#1f7fa0; --g2:#3f8f3a; --g3:#d18b17; --g4:#7a63b8; --g5:#8e2b4c; --g6:#7e8a91;
  --focus:#1b4d8c; color-scheme:light;
  box-sizing:border-box; padding-top:env(safe-area-inset-top,0px); padding-bottom:env(safe-area-inset-bottom,0px);
}
@media (prefers-color-scheme:dark){ :root:not([data-theme="light"]){
  --paper:#0f1d27; --panel:#142632; --ink:#e4ecf0; --ink-2:#9db0bb; --line:#26404f;
  --water:#16324a;
  --street:#4c6575; --street-dim:#22394a; --halo:#0f1d27; --plate:#2a64ad; --plate-ink:#ffffff;
  --g0:#f06a5f; --g1:#47b3d6; --g2:#6cbf5f; --g3:#f0b142; --g4:#a28ee0; --g5:#d0668c; --g6:#93a1a9;
  --focus:#7fb2ff; color-scheme:dark; }}
:root[data-theme="dark"]{
  --paper:#0f1d27; --panel:#142632; --ink:#e4ecf0; --ink-2:#9db0bb; --line:#26404f;
  --water:#16324a;
  --street:#4c6575; --street-dim:#22394a; --halo:#0f1d27; --plate:#2a64ad; --plate-ink:#ffffff;
  --g0:#f06a5f; --g1:#47b3d6; --g2:#6cbf5f; --g3:#f0b142; --g4:#a28ee0; --g5:#d0668c; --g6:#93a1a9;
  --focus:#7fb2ff; color-scheme:dark; }
*,*::before,*::after{box-sizing:border-box}
[hidden]{display:none!important}
html{height:100%;scroll-padding-top:env(safe-area-inset-top,0px)}
body{height:100%;margin:0;background:var(--paper);color:var(--ink);font-family:"Golos Text",system-ui,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;font-size:15px;line-height:1.45}
button{font:inherit;color:inherit}
button:focus-visible,input:focus-visible,.bar:focus-visible{outline:2px solid var(--focus);outline-offset:2px}
.app{height:100%;display:grid;grid-template-columns:minmax(0,1fr) 360px;grid-template-rows:minmax(0,1fr) auto}
.mapwrap{position:relative;grid-column:1;grid-row:1;overflow:hidden;touch-action:none;cursor:grab}
.mapwrap.drag{cursor:grabbing}
.mapwrap.onhouse{cursor:pointer}
.link{border:0;background:none;padding:0;font:inherit;font-weight:600;color:var(--ink);text-decoration:underline;text-decoration-color:var(--line);text-underline-offset:3px;cursor:pointer}
.link:hover{text-decoration-color:currentColor}
.meta .sw{display:inline-block;width:10px;height:10px;border-radius:2px;margin:0 6px 0 2px;vertical-align:0}
svg#map{width:100%;height:100%;display:block}
#water{pointer-events:none}
#water path{fill:var(--water)}
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
#houses{position:absolute;inset:0;width:100%;height:100%;pointer-events:none;display:none}
.houses-ui .hrow{display:flex;align-items:center;gap:8px;font-size:14px}
.houses-ui input{width:16px;height:16px;accent-color:var(--ink)}
.houses-ui .hcount{color:var(--ink-2);font-size:13px}
#hlegend{margin-top:8px;font-size:12px;color:var(--ink-2)}
#hlegend .hgrad{height:10px;border-radius:3px;border:1px solid var(--line)}
#hlegend .htags{display:flex;justify-content:space-between;margin-top:2px;font-variant-numeric:tabular-nums}
.houses-ui .hcolor{margin-top:10px;font-size:13px;flex-wrap:wrap;row-gap:3px}
.houses-ui .hcolor>span{color:var(--ink-2)}
.houses-ui .hcolor label{display:inline-flex;align-items:center;gap:4px;cursor:pointer;white-space:nowrap}
#hleg-street{margin-top:8px;display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:2px 14px}
#hleg-street .hsrow{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--ink-2);font-variant-numeric:tabular-nums;white-space:nowrap;overflow:hidden}
#hleg-street .hsrow .sw{width:10px;height:10px;border-radius:2px;flex:none}
aside{grid-column:2;grid-row:1 / span 2;background:var(--panel);border-left:1px solid var(--line);overflow-y:auto;padding:22px 22px 28px;display:flex;flex-direction:column;gap:20px}
h1{font-size:22px;line-height:1.2;margin:0;font-weight:800;letter-spacing:-.01em}
.lede{margin:6px 0 0;color:var(--ink-2);font-size:14px}
.plate{background:var(--plate);color:var(--plate-ink);border-radius:7px;padding:5px}
.plate{flex:none}
.plate-in{border:2px solid rgba(255,255,255,.9);border-radius:4px;padding:8px 14px 10px;min-height:92px;display:flex;flex-direction:column;justify-content:center;overflow:hidden}
.plate .kind{font-size:13px;font-weight:500;opacity:.92;margin:0}
.plate .name{font-size:26px;font-weight:800;line-height:1.1;margin:2px 0 0;letter-spacing:-.005em;overflow-wrap:break-word;hyphens:auto}
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
.app{overflow:hidden}
.info{grid-column:2;grid-row:1 / span 2;z-index:4;background:var(--panel);border-left:1px solid var(--line);box-shadow:-10px 0 28px rgba(0,0,0,.14);overflow-y:auto;overscroll-behavior:contain;padding:18px 22px 28px;transform:translateX(100%);visibility:hidden;transition:transform .22s ease,visibility 0s linear .22s}
.info.open{transform:none;visibility:visible;transition:transform .22s ease}
.overview{flex:1 0 auto;display:flex;flex-direction:column;gap:16px}
.back{display:inline-flex;align-items:center;gap:4px;border:0;background:transparent;color:var(--ink-2);font-weight:600;font-size:14px;padding:4px 6px;margin:0 0 8px -6px;border-radius:5px;cursor:pointer}
.back:hover{color:var(--ink);background:color-mix(in srgb,var(--ink) 8%,transparent)}
.info .rel{margin-top:16px}
.rel legend{display:flex;align-items:center;gap:8px;width:100%}
.rel button{grid-template-areas:"s i" !important;height:38px !important}
.rel button span{padding-left:0 !important;color:var(--ink) !important}
.rel button span::before{content:"";display:inline-block;width:8px;height:8px;border-radius:50%;border:1.5px solid var(--ink-2);margin-right:7px;vertical-align:1px}
.rel button[aria-pressed="true"] span::before{background:var(--ink);border-color:var(--ink)}
.gsw{width:12px;height:12px;border-radius:3px;background:var(--gc,var(--ink-2));flex:none}
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
.tl-note{margin:0;font-size:11px;line-height:1.3;color:var(--ink-2)}
.tl-note b{color:var(--ink);font-weight:600}
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
.bars.gfocus .seg-g:not(.gon){opacity:.28}
.legend button.hov{background:color-mix(in srgb,var(--ink) 8%,transparent)}
@media (max-width:860px){
  .app{grid-template-columns:1fr;grid-template-rows:62vh auto auto auto;height:auto;min-height:100%}
  html,body{height:auto}
  .mapwrap{grid-row:1;height:62vh}
  .timeline{grid-row:4}
  aside{grid-column:1;grid-row:3;border-left:0;border-top:1px solid var(--line);overflow:visible}
  .timeline{grid-template-columns:1fr}
  .tl-side{flex-direction:row;align-items:center;width:auto}
  #tlinfo{flex:1}
  .app{overflow:visible}
  .info{grid-column:1;grid-row:2;display:none;transform:none;visibility:visible;transition:none;box-shadow:none;border-left:0;padding:14px 16px}
  .info.open{display:block}
  .bar{flex:1 0 13px}
  .bars{gap:2px}
}
@media (prefers-reduced-motion:reduce){.s,.info,.info.open{transition:none}}
</style>
</head>
<body>
<noscript><p style="margin:0;padding:12px 16px;background:#fff3cd;color:#5c4400;font:15px system-ui,sans-serif">Карте нужен JavaScript. Откройте файл в браузере (Chrome, Firefox, Safari, Edge), а не в окне предпросмотра или почтовом клиенте.</p></noscript>
<div class="app">
  <div class="mapwrap" id="wrap">
    <svg id="map" role="img" aria-label="Карта улиц Владивостока, раскрашенная по тематикам названий">
      <g id="water" aria-hidden="true"></g><g id="capes"></g><g id="streets"></g><g id="top"></g><g id="hit"></g>
    </svg>
    <canvas id="houses" aria-hidden="true"></canvas>
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
      <p class="tl-note" id="tlnote"></p>
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
    </div>

    <div class="overview" id="overview">
      <section>
        <h2>Группы названий</h2>
        <ul class="legend" id="legend"></ul>
      </section>
      <section class="houses-ui">
        <h2>Дома (год постройки) <span class="hcount" id="hcount"></span></h2>
        <div id="hlegend">
          <div class="hrow hcolor" role="radiogroup" aria-label="Показ домов на карте">
            <span>Показать:</span>
            <label><input type="radio" name="hcolormode" value="off" checked> нет</label>
            <label><input type="radio" name="hcolormode" value="street"> по улице</label>
            <label><input type="radio" name="hcolormode" value="year"> по году</label>
          </div>
          <div id="hleg-year" hidden>
            <div class="hgrad" id="hgrad"></div>
            <div class="htags"><span id="hy0"></span><span id="hy1"></span></div>
          </div>
          <div id="hleg-street" hidden></div>
        </div>
      </section>
      <footer class="src"><details><summary>Источники и пояснения</summary>
        <p>Геометрия улиц — © участники OpenStreetMap (ODbL), выгрузка и годы названий — открытый проект <a href="https://github.com/skirienko/vvmap" target="_blank" rel="noopener">vvmap</a>.</p>
        <p>Год — когда улица получила нынешнее название или впервые упомянута в документах. Пик 1920-х во многом даёт справочник 1924 года.</p>
        <p>Тематическая классификация — составлена в нашем разговоре; около 5% названий помечены как требующие проверки.</p>
      </details></footer>
    </div>

  </aside>

  <section class="info" id="streetview" aria-live="polite">
    <button class="back" id="back" type="button" aria-label="Назад к обзору">← Назад</button>
    <div class="plate empty" id="plate"><div class="plate-in"><p class="kind" id="pkind">Владивосток</p><p class="name" id="pname">Выберите улицу на карте</p></div></div>
    <fieldset class="rel" id="relseg">
      <legend>Что подсвечивать вместе с улицей <span class="gsw" title="Цвет подсветки — цвет группы названия"></span></legend>
      <button data-m="group" aria-pressed="false" aria-label="Подсвечивать улицы той же группы"><span id="rv-group"></span><i id="rn-group"></i></button>
      <button data-m="cat" aria-pressed="true" aria-label="Подсвечивать улицы той же тематики"><span id="rv-cat"></span><i id="rn-cat"></i></button>
      <button data-m="sub" aria-pressed="false" aria-label="Подсвечивать улицы той же подтемы"><span id="rv-sub"></span><i id="rn-sub"></i></button>
    </fieldset>
    <div id="details"></div>
  </section>
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
// V15: вода (береговая линия OSM) — самый нижний слой; путь с fill-rule=evenodd:
// подпуть-прямоугольник + контуры суши, вода = нечётная глубина вложенности
if(DATA.water){
  const wp=document.createElementNS(NS,'path');
  wp.setAttribute('d',DATA.water.d);wp.setAttribute('fill-rule','evenodd');
  document.getElementById('water').appendChild(wp);
}
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
  drawHouses();
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
  if(!ptrs.size&&e.pointerType!=='touch'){
    const hi=houseAt(e.clientX,e.clientY); wrap.classList.toggle('onhouse',hi>=0);
    const prev=hoverHouse; if(hi!==prev){hoverHouse=hi;drawHouses();}
    if(hi>=0)showTip(e,houseTip(HD.houses[hi])); else if(prev>=0)hideTip();
  }
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
    const hi=houseAt(e.clientX,e.clientY);
    if(hi>=0){openHouse(hi,e);}
    else{
      const t=document.elementFromPoint(e.clientX,e.clientY);
      if(t&&t.parentNode===gHit){select(+t.dataset.i,false);} else if(!e.target.closest('.zoom')) clearPin();
    }
  }
}
wrap.addEventListener('pointerup',endPtr);wrap.addEventListener('pointercancel',endPtr);

// ---------- highlight state
let pinned=null;           // index of pinned street
let houseOpen=null;        // index of opened house (ФКР)
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
  else {clearHL();markDecade(null);if(houseOpen!=null)showHouse(houseOpen,null);else renderEmpty();}
  syncView();
}
// колонка: обзор (группы, дома) или карточка закреплённой улицы / дома
const streetview=document.getElementById('streetview');
let hovered=null;          // улица под курсором (подсвечена на карте, панель не открывает)
function syncView(){streetview.classList.toggle('open',pinned!=null||houseOpen!=null); if(housesOn&&drawnSel!==houseOpen)drawHouses();}
function openHouse(i,e){pinned=null;legendPinned=null;decPinned=null;hovered=null;syncPressed();houseOpen=i;clearHL();markDecade(null);showHouse(i,e);syncView();}
function select(i,zoom){
  pinned=i; legendPinned=null; decPinned=null; hovered=null; syncPressed(); showStreet(i); syncView();
  if(zoom){const bb=paths[i].getBBox(), r=wrap.getBoundingClientRect(), ar=r.width/r.height;
    let h=Math.max(bb.height*2.4,bb.width*2.4/ar,500), w=h*ar; view={x:bb.x+bb.width/2-w/2,y:bb.y+bb.height/2-h/2,w,h};apply();}
}
function clearPin(){pinned=null;legendPinned=null;decPinned=null;syncPressed();restore();}
function fitTo(ids){if(!ids.length)return;let x0=1e9,y0=1e9,x1=-1e9,y1=-1e9;ids.forEach(i=>{const b=paths[i].getBBox();x0=Math.min(x0,b.x);y0=Math.min(y0,b.y);x1=Math.max(x1,b.x+b.width);y1=Math.max(y1,b.y+b.height);});
  const r=wrap.getBoundingClientRect(),ar=r.width/r.height,pad=1.12;const w=Math.max((x1-x0)*pad,(y1-y0)*pad*ar,600*ar),h=w/ar;view={x:(x0+x1)/2-w/2,y:(y0+y1)/2-h/2,w,h};apply();}
function frameNote(ids){let k=0;ids.forEach(i=>{const b=paths[i].getBBox();if(b.x+b.width>=view.x&&b.x<=view.x+view.w&&b.y+b.height>=view.y&&b.y<=view.y+view.h)k++;});
  return k<ids.length?`<p class="meta">В кадре видно <b>${k}</b> из ${ids.length}, остальные за краем карты. Нажмите на столбик, чтобы показать все.</p>`:'';}

// hover on map
const somethingPinned=()=>pinned!=null||houseOpen!=null||legendPinned!=null||decPinned!=null;
gHit.addEventListener('pointerover',e=>{if(moved&&dragStart)return;const i=+e.target.dataset.i;if(e.pointerType!=='touch'){if(houseAt(e.clientX,e.clientY)>=0)return; // дом поверх улицы — приоритет у дома
  if(!somethingPinned()){hovered=i;showStreet(i);syncView();}showTip(e,F[i].n);}});
gHit.addEventListener('pointermove',e=>{if(e.pointerType!=='touch'&&!(moved&&dragStart))showTip(e,F[+e.target.dataset.i].n);});
gHit.addEventListener('pointerout',e=>{if(e.pointerType==='touch')return;const was=hovered;hovered=null;hideTip();if(was!=null)restore();});
function showTip(e,t){const r=wrap.getBoundingClientRect();tip.textContent=t;tip.style.left=(e.clientX-r.left)+'px';tip.style.top=(e.clientY-r.top)+'px';tip.style.display='block';}
function hideTip(){tip.style.display='none';}
document.addEventListener('keydown',e=>{if(e.key==='Escape'){clearPin();}});

// ---------- details panel
const plate=document.getElementById('plate'), pkind=document.getElementById('pkind'), pname=document.getElementById('pname'), details=document.getElementById('details');
// название на табличке: чем длиннее, тем мельче кегль (табличка растёт до 3 строк)
function setName(t,fit){pname.textContent=t;const L=t.length;pname.style.fontSize=fit?(L<=14?26:L<=20?22:L<=30?19:16)+'px':'';}
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
  plate.classList.remove('empty'); pkind.textContent=sp.kind||'улица'; setName(sp.name,true);
  relseg.hidden=false; relseg.style.setProperty('--gc','var(--g'+f.gi+')');
  const names=[...new Set(rel.map(j=>F[j].n))].filter(n=>n!==f.n).sort((a,b)=>splitName(a).name.localeCompare(splitName(b).name,'ru'));
  const shown=names.slice(0,16);
  const yr=f.y!=null?`<b>${f.y}</b>${f.yd?' — '+esc(f.yd):''}`:'год неизвестен';
  let hSum='';
  if(HD&&housesOn){const hs=hByStreet[f.n];
    if(hs&&hs.length){const ys=hs.map(h=>h[6]).filter(y=>y!=null);
      const mc={};hs.forEach(h=>{if(h[3]>=0){const m=HD.materials[h[3]];mc[m]=(mc[m]||0)+1;}});
      const top=Object.entries(mc).sort((a,b)=>b[1]-a[1]).slice(0,3).map(([m,c])=>esc(m)+' — '+c).join(', ');
      hSum='<p class="meta">Дома ФКР на этой улице: <b>'+hs.length+'</b>'+(ys.length?', постройка <b>'+Math.min(...ys)+'–'+Math.max(...ys)+'</b>':'')+(top?', материалы: '+top:'')+'.</p>';}}
  details.innerHTML=`
    ${f.o?`<p class="meta">${esc(f.o)}</p>`:''}
    <p class="meta">Название: ${yr}</p>
    ${hSum}
    ${f.u?'<p class="warn">Тематика определена предположительно, нужна проверка.</p>':''}
    <div class="rel-head"><p>${names.length} ${plural(names.length,'улица','улицы','улиц')} той же ${relLabel[relMode]}</p></div>
    <div class="chips">${shown.map(n=>`<button data-n="${esc(n)}">${esc(splitName(n).name)}</button>`).join('')}${names.length>shown.length?`<span class="more">и ещё ${names.length-shown.length}</span>`:''}</div>`;
}
function renderEmpty(){
  updRel(null);
  plate.classList.add('empty');pkind.textContent='Владивосток';setName('Выберите улицу на карте');
  details.innerHTML=''; syncView();
}
const relseg=document.getElementById('relseg');
document.getElementById('back').addEventListener('click',()=>clearPin());
relseg.addEventListener('click',e=>{
  const m=e.target.closest('[data-m]'); if(!m)return; relMode=m.dataset.m;
  document.querySelectorAll('#relseg [data-m]').forEach(b=>b.setAttribute('aria-pressed',String(b.dataset.m===relMode)));
  if(pinned!=null)showStreet(pinned);
});
details.addEventListener('click',e=>{
  const c=e.target.closest('[data-n]'); if(c){select(byName[c.dataset.n][0],true);}
});
let curHover=null; gHit.addEventListener('pointerover',e=>{curHover=+e.target.dataset.i});

// ---------- houses layer (ФКР, V4)
const HD=DATA.houses||null;
const hcv=document.getElementById('houses'), hctx=hcv.getContext('2d');
const hModeRadios=document.querySelectorAll('input[name="hcolormode"]'),
      hCount=document.getElementById('hcount'), hGrad=document.getElementById('hgrad'),
      hy0=document.getElementById('hy0'), hy1=document.getElementById('hy1'),
      hLegYear=document.getElementById('hleg-year'), hLegStreet=document.getElementById('hleg-street');
let housesOn=false;
let cumulYear=null;      // текущий год анимации роста (null — обычный режим: все дома)
const H_LASTYEAR=D1+9;   // финал анимации «к 2029»: дома без года появляются здесь
const hByStreet={};
if(HD)HD.houses.forEach(h=>{if(h[5]!=null){const k=HD.street_names[h[5]];(hByStreet[k]=hByStreet[k]||[]).push(h);}});
let hColorMode='street'; // 'year' — десятилетие постройки, 'street' — группа улицы
const hStreetGi=HD?HD.street_names.map(n=>{const ids=byName[n];return ids&&ids.length?F[ids[0]].gi:-1;}):[];
function giPalette(){
  const cs=getComputedStyle(document.documentElement);
  return GROUPS.map((_,gi)=>(cs.getPropertyValue('--g'+gi)||'').trim()||'#9a9a9a');
}
function houseColor(h,pal){
  if(hColorMode==='street'){
    const gi=h[5]!=null?hStreetGi[h[5]]:-1;
    return gi>=0?pal[gi]:'#9a9a9a'; // без привязки к улицам карты — серый
  }
  return h[2]<0?'#9a9a9a':decColor(h[2]);
}
function decColor(i){
  const n=HD.decades.length, t=n>1?i/(n-1):0;
  const c0=[26,54,124], c1=[228,140,26]; // тёмно-синий -> янтарь (отличимо от категорийных цветов групп)
  return 'rgb('+Math.round(c0[0]+(c1[0]-c0[0])*t)+','+Math.round(c0[1]+(c1[1]-c0[1])*t)+','+Math.round(c0[2]+(c1[2]-c0[2])*t)+')';
}
function houseVisible(h){
  if(cumulYear==null)return true;
  if(h[6]==null)return cumulYear>=H_LASTYEAR; // дом без года — в самом конце анимации
  return h[6]<=cumulYear;
}
function drawHouses(){
  const r=wrap.getBoundingClientRect();
  const w=Math.max(1,Math.round(r.width)), hh=Math.max(1,Math.round(r.height));
  const dpr=window.devicePixelRatio||1;
  if(hcv.width!==Math.round(w*dpr)||hcv.height!==Math.round(hh*dpr)){hcv.width=Math.round(w*dpr);hcv.height=Math.round(hh*dpr);}
  hctx.setTransform(dpr,0,0,dpr,0,0);
  hctx.clearRect(0,0,w,hh);
  if(!housesOn||!HD)return;
  const sx=r.width/view.w, sy=r.height/view.h, rad=2.7;
  const pal=hColorMode==='street'?giPalette():null;
  for(const h of HD.houses){
    if(!houseVisible(h))continue;
    const px=(h[0]-view.x)*sx, py=(h[1]-view.y)*sy;
    if(px<-rad||py<-rad||px>w+rad||py>hh+rad)continue;
    hctx.beginPath();
    hctx.fillStyle=houseColor(h,pal);
    hctx.arc(px,py,rad,0,6.2832);
    hctx.fill();
  }
  drawnSel=houseOpen;
  const cs=getComputedStyle(document.documentElement), halo=cs.getPropertyValue('--halo').trim(), ink=cs.getPropertyValue('--ink').trim();
  if(hoverHouse>=0&&houseVisible(HD.houses[hoverHouse])){ // дом под курсором — крупная точка с ореолом, как улица
    const h=HD.houses[hoverHouse], px=(h[0]-view.x)*sx, py=(h[1]-view.y)*sy;
    hctx.beginPath();hctx.arc(px,py,5.5,0,6.2832);hctx.fillStyle=houseColor(h,pal);hctx.fill();
    hctx.lineWidth=3;hctx.strokeStyle=halo;hctx.stroke();
    hctx.beginPath();hctx.arc(px,py,7,0,6.2832);hctx.lineWidth=1.5;hctx.strokeStyle=ink;hctx.stroke();
  }
  if(houseOpen!=null&&houseVisible(HD.houses[houseOpen])){ // выбранный дом — кольцо с ореолом
    const h=HD.houses[houseOpen], px=(h[0]-view.x)*sx, py=(h[1]-view.y)*sy;
    hctx.lineWidth=5;hctx.strokeStyle=halo;hctx.beginPath();hctx.arc(px,py,7,0,6.2832);hctx.stroke();
    hctx.lineWidth=2.5;hctx.strokeStyle=ink;hctx.beginPath();hctx.arc(px,py,7,0,6.2832);hctx.stroke();
  }
}
let drawnSel=null, hoverHouse=-1;
wrap.addEventListener('pointerleave',()=>{wrap.classList.remove('onhouse');if(hoverHouse>=0){hoverHouse=-1;drawHouses();hideTip();}});
function houseTip(h){const y=h[6]!=null?h[6]:(h[2]>=0?HD.decades[h[2]]+'-е':'год неизвестен');return (h[7]||'').replace(/^г\. Владивосток, /,'')+' · '+y;}
function houseAt(cx,cy){
  if(!housesOn||!HD)return -1;
  const r=wrap.getBoundingClientRect(), sx=r.width/view.w, sy=r.height/view.h;
  const px=cx-r.left, py=cy-r.top;
  let best=-1, bd=49; // порог 7 px
  for(let i=0;i<HD.houses.length;i++){
    const h=HD.houses[i];
    if(!houseVisible(h))continue;
    const dx=(h[0]-view.x)*sx-px, dy=(h[1]-view.y)*sy-py, d=dx*dx+dy*dy;
    if(d<bd){bd=d;best=i;}
  }
  return best;
}
function showHouse(i,e){
  const h=HD.houses[i];
  const year=h[6]!=null?h[6]:(h[2]>=0?HD.decades[h[2]]+'-е':'—');
  const mat=h[3]>=0?HD.materials[h[3]]:'материал не указан';
  const fl=h[4]>0?h[4]:null;
  plate.classList.remove('empty'); pkind.textContent='дом (ФКР)'; relseg.hidden=true;
  setName((h[7]||(h[5]!=null?HD.street_names[h[5]]:'адрес неизвестен')).replace(/^г\. Владивосток, /,''),true);
  const sn=h[5]!=null?HD.street_names[h[5]]:null, sgi=sn!=null?hStreetGi[h[5]]:-1;
  details.innerHTML=(sn!=null&&byName[sn]?'<p class="meta">Улица: <span class="sw" style="background:var(--g'+sgi+')"></span><button class="link" data-n="'+esc(sn)+'">'+esc(sn)+'</button></p>':'')
    +'<p class="meta">Год постройки: <span class="sw" style="background:'+(h[2]>=0?decColor(h[2]):'#9a9a9a')+'"></span><b>'+year+(h[2]>=0&&h[6]!=null?' ('+HD.decades[h[2]]+'-е)':'')+'</b></p>'
    +'<p class="meta">Материал стен: <b>'+esc(mat)+'</b></p>'
    +(fl?'<p class="meta">Этажей: <b>'+fl+'</b></p>':'')
    +(sn!=null&&byName[sn]?'':'<p class="warn">Дом не сопоставлен с улицами карты (нет связи по названию).</p>');
  if(e)showTip(e,(h[7]||'')+' · '+year+' · '+mat+(fl?' · '+fl+' эт.':''));
}
function syncHLegend(){
  hLegYear.hidden=!housesOn||hColorMode!=='year';
  hLegStreet.hidden=!housesOn||hColorMode!=='street';
}
if(HD){
  hCount.textContent=HD.houses.length+' домов';
  { // легенда режима «по улице»: групповые цвета + счётчик домов, серый — без улицы карты
    const cnt=Array(GROUPS.length).fill(0); let un=0;
    HD.houses.forEach(h=>{const gi=h[5]!=null?hStreetGi[h[5]]:-1;if(gi>=0)cnt[gi]++;else un++;});
    let html='';
    GROUPS.forEach((g,gi)=>{if(!cnt[gi])return;html+='<div class="hsrow"><span class="sw" style="background:var(--g'+gi+')"></span>'+esc(GSHORT[gi])+' — '+cnt[gi]+'</div>';});
    html+='<div class="hsrow"><span class="sw" style="background:#9a9a9a"></span>без улицы карты — '+un+'</div>';
    hLegStreet.innerHTML=html;
  }
  { const n=HD.decades.length;
    hGrad.style.background='linear-gradient(90deg,'+decColor(0)+','+decColor(Math.floor(n/2))+','+decColor(n-1)+')';
    hy0.textContent=HD.decades[0]+'-е'; hy1.textContent=HD.decades[n-1]+'-е'; }
  // «нет» — слой выключен; «по году» / «по улице» — слой включён с этой раскраской
  hModeRadios.forEach(r=>r.addEventListener('change',()=>{
    if(!r.checked)return;
    const wasOn=housesOn; housesOn=r.value!=='off'; if(housesOn)hColorMode=r.value;
    hcv.style.display=housesOn?'block':'none'; syncHLegend();
    if(housesOn){drawHouses(); if(!wasOn&&pinned!=null)showStreet(pinned);}
    else{hideTip();hoverHouse=-1;wrap.classList.remove('onhouse');houseOpen=null;restore();}
  }));
  // смена системной темы — перекрасить уже нарисованные дома
  if(window.matchMedia)matchMedia('(prefers-color-scheme:dark)').addEventListener('change',()=>{if(housesOn)drawHouses();});
} else { hModeRadios.forEach(r=>r.disabled=true); hCount.textContent='нет данных'; }

// ---------- legend
const legend=document.getElementById('legend'); let legendPinned=null;
GROUPS.forEach((g,gi)=>{
  const li=document.createElement('li'), n=(byKey.group[g]||[]).length;
  li.innerHTML=`<button data-g="${gi}" aria-pressed="false"><span class="sw" style="background:var(--g${gi})"></span><span>${esc(GSHORT[gi])}</span><span class="n">${n}</span></button>`;
  legend.appendChild(li);
});
function showGroup(gi){showSet(byKey.group[GROUPS[gi]]||[]);markDecade(null);
  plate.classList.add('empty');pkind.textContent='группа';setName(GROUPS[gi]);
  const cats={};(byKey.group[GROUPS[gi]]||[]).forEach(j=>{cats[F[j].c]=(cats[F[j].c]||0)+1;});
  details.innerHTML=`<p class="meta">${Object.entries(cats).sort((a,b)=>b[1]-a[1]).map(([c,n])=>`${esc(c)}: <b>${n}</b>`).join('<br>')}</p>`;}
// группа под курсором — синхронно в легенде сайдбара и в сегментах таймлайна
function linkGroup(gi){
  legend.querySelectorAll('[data-g]').forEach(b=>b.classList.toggle('hov',+b.dataset.g===gi));
  bars.classList.toggle('gfocus',gi!=null);
  bars.querySelectorAll('.seg-g').forEach(s=>s.classList.toggle('gon',+s.dataset.g===gi));
}
legend.addEventListener('pointerover',e=>{const b=e.target.closest('[data-g]');if(!b)return;if(!playing)linkGroup(+b.dataset.g);if(pinned==null)showGroup(+b.dataset.g);});
legend.addEventListener('pointerleave',()=>{linkGroup(null);restore();});
legend.addEventListener('click',e=>{const b=e.target.closest('[data-g]');if(!b)return;const gi=+b.dataset.g;
  if(legendPinned===gi){legendPinned=null;}else{pinned=null;decPinned=null;legendPinned=gi;fitTo(byKey.group[GROUPS[gi]]||[]);} syncPressed(); restore();});
function syncPressed(){houseOpen=null; // любое закрепление снимает открытый дом
  legend.querySelectorAll('[data-g]').forEach(b=>b.setAttribute('aria-pressed',String(+b.dataset.g===legendPinned)));
  bars.querySelectorAll('.bar').forEach(b=>b.classList.toggle('on',+b.dataset.d===decPinned));}

// ---------- timeline
const bars=document.getElementById('bars'), tlinfo=document.getElementById('tlinfo'), stamp=document.getElementById('stamp');
if(DATA.names_unique)document.getElementById('tlnote').innerHTML='Линии на карте; уникальных названий: <b>'+DATA.names_unique+'</b>';
const decs=[];for(let d=D0;d<=D1;d+=10)decs.push(d);
const maxN=Math.max(...decs.map(d=>(byDec[d]||[]).length));
decs.forEach(d=>{
  const ids=byDec[d]||[], b=document.createElement('div');b.className='bar';b.dataset.d=d;b.tabIndex=0;
  b.setAttribute('role','button');b.setAttribute('aria-label',`${d}-е: ${ids.length} ${plural(ids.length,'улица','улицы','улиц')}`);
  const cnt=GROUPS.map(()=>0);ids.forEach(i=>cnt[F[i].gi]++);
  const H=78; // px for max
  cnt.forEach((c,gi)=>{if(!c)return;const s=document.createElement('div');s.className='seg-g';s.dataset.g=gi;s.style.height=(c/maxN*H)+'px';s.style.background=`var(--g${gi})`;b.appendChild(s);});
  const lab=document.createElement('span');lab.className='lab';lab.textContent=(d%20===0||d===D1)?String(d):'';b.appendChild(lab);
  bars.appendChild(b);
});
let decPinned=null;
function decText(d){const ids=byDec[d]||[];const cnt=GROUPS.map(()=>0);ids.forEach(i=>cnt[F[i].gi]++);
  const top=cnt.map((c,gi)=>[c,gi]).filter(x=>x[0]).sort((a,b)=>b[0]-a[0]).slice(0,2).map(([c,gi])=>`${GSHORT[gi].toLowerCase()} ${c}`).join(', ');
  return `<strong>${d}-е: ${ids.length}</strong>${top}`;}
function showDecade(d){showSet(byDec[d]||[]);markDecade(d);tlinfo.innerHTML=decText(d);
  plate.classList.add('empty');pkind.textContent='десятилетие';setName(`${d}-е годы`);
  const ids=byDec[d]||[];const names=[...new Set(ids.map(j=>F[j].n))].sort((a,b)=>(F[byName[a][0]].y-F[byName[b][0]].y));
  details.innerHTML=`<p class="meta">${ids.length} ${plural(ids.length,'улица получила','улицы получили','улиц получили')} нынешнее название в эти годы.</p>${frameNote(ids)}<div class="chips">${names.slice(0,24).map(n=>`<button data-n="${esc(n)}">${esc(splitName(n).name)} <span style="color:var(--ink-2)">${F[byName[n][0]].y}</span></button>`).join('')}${names.length>24?`<span class="more">и ещё ${names.length-24}</span>`:''}</div>`;}
function markDecade(d){bars.querySelectorAll('.bar').forEach(b=>b.classList.toggle('mark',d!=null&&+b.dataset.d===d));}
bars.addEventListener('pointerover',e=>{const b=e.target.closest('.bar');if(!b||playing)return;
  const sg=e.target.closest('.seg-g'), d=+b.dataset.d, gi=sg?+sg.dataset.g:null;
  linkGroup(gi);
  if(pinned!=null)return;
  if(gi==null){showDecade(d);return;}
  // сегмент: улицы этой группы, получившие название в этом десятилетии
  const ids=(byDec[d]||[]).filter(i=>F[i].gi===gi);
  showSet(ids);markDecade(d);tlinfo.innerHTML=`<strong>${d}-е: ${ids.length} из ${(byDec[d]||[]).length}</strong>${esc(GSHORT[gi].toLowerCase())}`;
});
bars.addEventListener('pointerleave',()=>{linkGroup(null);if(!playing){tlinfo.innerHTML='<strong>Годы названий</strong>Наведите или нажмите на десятилетие';restore();}});
bars.addEventListener('click',e=>{const b=e.target.closest('.bar');if(!b)return;stopPlay();const d=+b.dataset.d;
  if(decPinned===d)decPinned=null;else{decPinned=d;pinned=null;legendPinned=null;fitTo(byDec[d]||[]);} syncPressed();restore();});
bars.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();e.target.click();}});
bars.addEventListener('focusin',e=>{const b=e.target.closest('.bar');if(b&&!playing)showDecade(+b.dataset.d);});

// cumulative "growth" animation
let playing=false, raf=null;
const playBtn=document.getElementById('play');
const SLOT=900; // мс на десятилетие — как в V6/V9
function clearCumul(){if(!svg.classList.contains('cumul'))return;svg.classList.remove('cumul');paths.forEach(p=>p.classList.remove('future','fresh'));bars.classList.remove('dimmed');bars.querySelectorAll('.bar').forEach(b=>b.classList.remove('past'));stamp.textContent='';cumulYear=null;drawHouses();}
function cumulState(d){ // улицы/бары/штамп — раз на границе десятилетия, поведение V6/V9
  clearHL(); markDecade(null); svg.classList.add('cumul'); bars.classList.add('dimmed');
  F.forEach((f,i)=>{const fut=f.dec==null||f.dec>d;paths[i].classList.toggle('future',fut);paths[i].classList.toggle('fresh',f.dec===d);});
  bars.querySelectorAll('.bar').forEach(b=>{b.classList.toggle('past',+b.dataset.d<=d);b.classList.toggle('on',+b.dataset.d===d);});
  stamp.textContent=`${d}-е`;
}
let cumulYy=-1; // точный год счётчика, уже показанный на текущем слоте
function cumulTick(d,cy){ // тик внутри десятилетия (V11): cumulYear интерполируется непрерывно от d к d+9
  cumulYear=cy; // дома «выезжают» по годам постройки: видны дома с годом ≤ cy (годы целые); дом без года — только при cy≥H_LASTYEAR
  const y=Math.floor(cy);
  if(y!==cumulYy){ // счётчики — вживую вместе с cumulYear (по точному году, не раз в десятилетие)
    cumulYy=y;
    const total=F.filter(f=>f.y!=null&&f.y<=cy).length; // на границе десятилетия совпадает со счётом по f.dec (dec выводится из y)
    tlinfo.innerHTML=`<strong>к ${y} г.: ${total}</strong>новых за десятилетие: ${F.filter(f=>f.y!=null&&f.y>=d&&f.y<=cy).length}`;
  }
  drawHouses();
}
function stopPlay(){if(!playing)return;playing=false;if(raf)cancelAnimationFrame(raf);playBtn.textContent='▶ Показать рост';}
playBtn.onclick=()=>{
  if(playing){stopPlay();return;}
  pinned=null;legendPinned=null;decPinned=null;syncPressed();renderEmpty();
  playing=true;playBtn.textContent='❚❚ Пауза';
  let k=0,t0=performance.now();
  cumulYy=-1;cumulState(decs[k]);cumulTick(decs[k],decs[k]);
  const step=()=>{
    if(!playing)return;
    const d=decs[k], p=Math.min(1,(performance.now()-t0)/SLOT);
    cumulTick(d,d+9*p); // плавный рост внутри десятилетия; длительность слота прежняя
    if(p<1){raf=requestAnimationFrame(step);return;}
    k++;
    if(k>=decs.length){stopPlay();setTimeout(()=>{if(!playing){clearCumul();tlinfo.innerHTML='<strong>Годы названий</strong>Наведите или нажмите на десятилетие';restore();}},1800);return;}
    t0=performance.now();cumulYy=-1;cumulState(decs[k]);cumulTick(decs[k],decs[k]);
    raf=requestAnimationFrame(step);
  };
  raf=requestAnimationFrame(step);
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
