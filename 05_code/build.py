import json
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment
rows=json.load(open('rows.json',encoding='utf-8'))
GORDER=['Персоналии','География','Природа','Тематические (нарицательные)','Описательные и ориентирующие','События и символика','Прочее / неясно']
from collections import OrderedDict, Counter
cats=OrderedDict()
cnt=Counter((r['group'],r['cat']) for r in rows)
for g in GORDER:
    for (gg,c),n in sorted(cnt.items(),key=lambda kv:-kv[1]):
        if gg==g: cats[(g,c)]=n
rows.sort(key=lambda r:(GORDER.index(r['group']),-cnt[(r['group'],r['cat'])],r['cat'],r['sub'],r['name']))
F='Arial'; HF=PatternFill('solid',fgColor='F3F3F3'); B=Font(name=F,bold=True); N=Font(name=F)
wb=Workbook()
st=wb.active; st.title='Статистика'
ls=wb.create_sheet('Улицы')
hdr=['Название','Тип','Группа','Тематика','Подтема','Уверенность','Примечание']
ls.append(hdr)
for r in rows: ls.append([r['name'],r['type'],r['group'],r['cat'],r['sub'],r['conf'],r['note'] or None])
last=len(rows)+1
for c in ls[1]: c.font=B; c.fill=HF
for row in ls.iter_rows(min_row=2):
    for c in row: c.font=N
for col,w in zip('ABCDEFG',[26,11,28,36,34,16,48]): ls.column_dimensions[col].width=w
ls.freeze_panes='A2'
L=f"Улицы!$C$2:$C${last}"; K=f"Улицы!$D$2:$D${last}"; T=f"Улицы!$B$2:$B${last}"; E=f"Улицы!$E$2:$E${last}"
st.column_dimensions['A'].width=3
for col,w in zip('BCDE',[32,40,12,10]): st.column_dimensions[col].width=w
def w(cell,v,font=N,fmt=None):
    st[cell]=v; st[cell].font=font
    if fmt: st[cell].number_format=fmt
w('B2','Улицы Владивостока по тематикам',Font(name=F,bold=True,size=14))
w('B3','Источник списка: vladivostok.ginfo.ru/ulicy (ноябрь 2026); без садовых товариществ, скверов и площадей. Классификация — авторская, см. столбец «Уверенность».',Font(name=F,italic=True,color='666666'))
# headline
heads=[('Всего объектов',f'=COUNTA(Улицы!$A$2:$A${last})'),('Улиц',f'=COUNTIF({T},"улица")'),('Переулков',f'=COUNTIF({T},"переулок")'),('Проспектов и шоссе',f'=COUNTIF({T},"проспект")+COUNTIF({T},"шоссе")'),('Названы в честь людей',f'=COUNTIF({L},"Персоналии")'),('Доля «людских» названий','=C9/C5')]
r=5
for lab,f in heads:
    w(f'B{r}',lab); w(f'C{r}',f,B,'0.0%' if 'Доля' in lab else '0'); r+=1
# table 1
r+=1; w(f'B{r}','По крупным группам',B); r+=1
t1h=r
for i,h in enumerate(['Группа','Кол-во','Доля']):
    c=st.cell(row=r,column=2+i,value=h); c.font=B; c.fill=HF
r+=1; t1s=r
for g in GORDER:
    w(f'B{r}',g); w(f'C{r}',f'=COUNTIF({L},B{r})',N,'0'); w(f'D{r}',f'=C{r}/$C$5',N,'0.0%'); r+=1
t1e=r-1
# table 2
r+=1; w(f'B{r}','По тематикам',B); r+=1
for i,h in enumerate(['Группа','Тематика','Кол-во','Доля']):
    c=st.cell(row=r,column=2+i,value=h); c.font=B; c.fill=HF
r+=1
for (g,c),n in cats.items():
    w(f'B{r}',g); w(f'C{r}',c); w(f'D{r}',f'=COUNTIFS({L},B{r},{K},C{r})',N,'0'); w(f'E{r}',f'=D{r}/$C$5',N,'0.0%'); r+=1
# table 3 cross themes
r+=1; w(f'B{r}','Сквозные темы (из разных групп)',B); r+=1
for i,h in enumerate(['Тема','Что входит','Кол-во']):
    c=st.cell(row=r,column=2+i,value=h); c.font=B; c.fill=HF
r+=1
cross=[('Море и флот','флотоводцы и капитаны, корабли, морская лексика, моря и океаны',f'=COUNTIF({K},"Флот и мореплаватели")+COUNTIF({K},"Корабли")+COUNTIF({K},"Море, флот, порт")+COUNTIF({E},"Моря и океаны")'),
('Война и армия','военачальники и герои, лётчики, армейская лексика, сражения',f'=COUNTIF({K},"Военачальники и герои войн")+COUNTIF({K},"Армия и крепость")+COUNTIF({E},"Сражения и подвиги")+COUNTIF({E},"Авиация")'),
('Культура','писатели, художники, композиторы',f'=COUNTIF({K},"Писатели и поэты")+COUNTIF({K},"Художники и скульпторы")+COUNTIF({K},"Композиторы и исполнители")'),
('Дальний Восток','исследователи края, топонимы ДВ, реки Сибири и ДВ, местные революционеры',f'=COUNTIF({K},"Исследователи и освоители края")+COUNTIF({K},"Приморье и Дальний Восток")+COUNTIF({E},"Реки Сибири и Дальнего Востока")+COUNTIF({E},"Дальневосточные революционеры")'),
('Советская эпоха','символика, революционеры и деятели, Гражданская война',f'=COUNTIF({K},"Советская символика и события")+COUNTIF({K},"Политики, революционеры, госдеятели")-COUNTIF({E},"Монархи")+COUNTIF({E},"Гражданская война")')]
for a,b,f in cross:
    w(f'B{r}',a); w(f'C{r}',b); w(f'D{r}',f,N,'0'); r+=1
r+=1; w(f'B{r}','Сквозные темы пересекаются, поэтому их сумма больше общего числа улиц.',Font(name=F,italic=True,color='666666'))
wb.save('/mnt/user-data/outputs/vladivostok_streets.xlsx')
print(last,r)
