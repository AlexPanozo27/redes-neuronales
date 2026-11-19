import os,shutil,re
D=os.path.dirname(os.path.abspath(__file__))
OUT=os.path.join(D,'site')
BASE='https://alexpanozo27.github.io/redes-neuronales'
LABS=[("1-neurona","neurona","1.1","La neurona que decide si cruzas la calle","Construye la primera neurona artificial de la historia (1943).","#D97706"),
("2-perceptron","perceptron","1.2","Enséñale a una neurona a llevar paraguas","Mira cómo una neurona aprende de sus errores, y dónde se atasca.","#0E7490"),
("3-lenguas","lenguas","1.3","¿Cuánto aymara sabe la máquina?","Investiga cómo traduce la IA al aymara, quechua y guaraní.","#B4235A"),
("4-habitacion","habitacion-china","2.1","Encerrado en la habitación china","Conversa en chino sin saber chino. ¿Eso es entender?","#B91C1C"),
("5-gato","gato","2.2","¿Es un gato? Reglas contra ejemplos","Un duelo entre reglas escritas a mano y una neurona que aprende.","#7C3AED"),
("6-palabras","palabras","2.3","Una máquina que escribe palabra por palabra","Un mini ChatGPT que solo leyó este capítulo, con temperatura.","#15803D"),
("7-mito","mito-o-realidad","2.4","¿Mito o realidad?","Doce afirmaciones para poner a prueba lo que aprendiste.","#C2410C")]
LABS2=[("c2-1-neurona-biologica","neurona-biologica","10.1","De la neurona del cerebro a la de la máquina","Toca cada parte de una neurona real y mira en qué se convirtió.","#0F766E"),
("c2-2-nodo","nodo","10.2","Arma tu propio nodo","Pesos, sesgo y activación: decide si Chispa sale a correr.","#1D4ED8"),
("c2-3-algoritmos","algoritmos","10.3","¿Receta o ejemplos?","Diez casos reales: ¿algoritmo clásico o red neuronal?","#9333EA"),
("c2-4-fases","fases","10.4","Arma el proyecto paso a paso","Ordena las fases de una app que detecta tizón en la papa.","#B45309"),
("c2-5-ingenieria-de-sistemas","ingenieria-de-sistemas","17.2","Vigila el servidor con una red neuronal","Ajusta una alarma de anomalías como un equipo de sistemas.","#0369A1")]
CAPS=[("c1","I","Fundamentos e historia de la IA",LABS),("c2","II","Redes neuronales: la anatomía de una máquina que aprende",LABS2)]
head=open(D+'/head.html').read().strip(); css=open(D+'/common.css').read(); js=open(D+'/common.js').read()
def page(s,lang='es'):
    s=s.replace('<!--HEAD-->',head).replace('/*COMMON*/',css).replace('/*COMMONJS*/',js)
    return f'<!doctype html>\n<html lang="{lang}"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><meta name="description" content="Laboratorio interactivo del libro Redes Neuronales en Mortales"></head><body>{s}</body></html>\n'
if os.path.exists(OUT): shutil.rmtree(OUT)
os.makedirs(OUT)
allcards={}
for cd,rom,ctit,labs in CAPS:
  os.makedirs(f'{OUT}/{cd}')
  for k,(src,slug,sec,title,desc,col) in enumerate(labs):
    s=open(f'{D}/{src}.html').read()
    prev=labs[k-1] if k>0 else None; nxt=labs[k+1] if k<len(labs)-1 else None
    nav='<nav class="row" style="justify-content:space-between;gap:10px" aria-label="Otros laboratorios">'
    nav+=(f'<a class="btn" href="../{prev[1]}/">← {prev[2]}</a>' if prev else '<span></span>')
    nav+='<a class="btn" href="../">Todos los laboratorios</a>'
    nav+=(f'<a class="btn" href="../{nxt[1]}/">{nxt[2]} →</a>' if nxt else '<span></span>')+'</nav>'
    nav=nav.replace('class="btn"','class="btn" style="text-decoration:none;display:inline-flex;align-items:center"')
    s=s.replace('<footer>',nav+'\n  <footer>',1)
    os.makedirs(f'{OUT}/{cd}/{slug}')
    open(f'{OUT}/{cd}/{slug}/index.html','w').write(page(s))
  cards="\n".join(f'    <a class="lab" href="{slug}/" style="--c:{col}"><span class="tag">Laboratorio {sec}</span><b>{title}</b><span class="d">{desc}</span><span class="go">Entrar →</span></a>' for (src,slug,sec,title,desc,col) in labs)
  allcards[cd]=cards
  hub=open(D+'/hub.html').read().replace('<!--LABS-->',cards).replace('Capítulo I',f'Capítulo {rom}')
  open(f'{OUT}/{cd}/index.html','w').write(page(hub))
cards=allcards['c1']
rootcards=cards.replace('href="','href="c1/')
root=open(D+'/hub.html').read().replace('<!--LABS-->',rootcards).replace('<title>Laboratorios del Capítulo I</title>','<title>Redes Neuronales en Mortales</title>').replace('<h1>Laboratorios del Capítulo I</h1>','<h1>Redes Neuronales en Mortales</h1>').replace('<span class="tag">Capítulo I</span>','<span class="tag">Laboratorios interactivos</span>')
root=root.replace('<section class="labs">','<h2>Capítulo I · Fundamentos e historia de la IA</h2>\n  <section class="labs">').replace('  </section>\n  <footer>','  </section>\n  <h2>Capítulo II · Redes neuronales: la anatomía de una máquina que aprende</h2>\n  <section class="labs">\n'+allcards['c2'].replace('href="','href="c2/')+'\n  </section>\n  <footer>',1).replace('<p class="lede">Cada QR','<p class="lede">El libro se lee en papel y se experimenta aquí. Cada QR')
open(f'{OUT}/index.html','w').write(page(root))
nf=page('<title>Página no encontrada</title><!--HEAD--><style>/*COMMON*/</style><div class="wrap"><div data-chispa="sad" class="chispa"></div><h1>Esta página no existe</h1><p class="lede">Quizá la dirección se escribió con un error. Revisa la dirección impresa bajo el QR o entra a la lista de laboratorios.</p><a class="btn primary" style="text-decoration:none;width:max-content" href="/redes-neuronales/c1/">Ver los laboratorios del Capítulo I</a></div><script>/*COMMONJS*/</script>')
open(f'{OUT}/404.html','w').write(nf)
open(f'{OUT}/.nojekyll','w').write('')
open(f'{OUT}/README.md','w').write("# Redes Neuronales en Mortales · Laboratorios\n\nLaboratorios interactivos enlazados desde los códigos QR del libro *Redes Neuronales en Mortales*.\n\nSitio: "+BASE+"/\n\n| Sección | Laboratorio | Dirección |\n|---|---|---|\n"+"\n".join(f"| {sec} | {title} | {BASE}/{cd}/{slug}/ |" for cd,_,_,labs in CAPS for (src,slug,sec,title,desc,col) in labs)+"\n\nLas páginas son HTML estático, sin servidor ni recolección de datos. **No cambies las direcciones `c1/...` ni `c2/...`: están impresas en el libro.**\n")
print("ok", sorted(os.listdir(OUT)))
