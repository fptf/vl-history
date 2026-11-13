# Подстановка __DATA__ (содержимое 05_code/data.json) в map_template.html.tpl -> карта-одиночный HTML.
# python, а не sed: в JSON есть спецсимволы. Запуск: python3 05_code/assemble.py (cwd не важен).
import os
HERE=os.path.dirname(os.path.abspath(__file__))
tpl=open(os.path.join(HERE,'map_template.html.tpl'),encoding='utf-8').read()
data=open(os.path.join(HERE,'data.json'),encoding='utf-8').read()
assert '__DATA__' in tpl, 'нет метки __DATA__ в шаблоне'
html=tpl.replace('__DATA__',data)
assert '__DATA__' not in html, 'подстановка прошла не полностью'
out=os.path.normpath(os.path.join(HERE,'..','04_prototype','vladivostok-streets-map.html'))
open(out,'w',encoding='utf-8').write(html)
print('map',os.path.getsize(out),'bytes ->',out)
