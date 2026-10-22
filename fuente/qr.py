import segno,os,sys
BASE='https://alexpanozo27.github.io/redes-neuronales'
SLUGS=[("1.1","neurona"),("1.2","perceptron"),("1.3","lenguas"),("2.1","habitacion-china"),("2.2","gato"),("2.3","palabras"),("2.4","mito-o-realidad")]
OUT=sys.argv[1]
os.makedirs(OUT,exist_ok=True)
rows=[]
for sec,slug in SLUGS:
    u=f"{BASE}/c1/{slug}/"
    q=segno.make(u,error='q')
    n=f"qr-{sec.replace('.','-')}-{slug}"
    q.save(f"{OUT}/{n}.svg",scale=10,border=4,dark='#0A2540')
    q.save(f"{OUT}/{n}.png",scale=24,border=4,dark='#0A2540')
    rows.append((sec,slug,u,n))
with open(f"{OUT}/LEEME.md","w") as f:
    f.write("# QR definitivos del Capítulo I\n\nUsar los **.svg** para la imprenta (vectoriales, no pierden calidad). Tamaño recomendado: al menos 2 × 2 cm. Imprimir debajo de cada QR la dirección corta.\n\n| Sección | Archivo | Dirección impresa |\n|---|---|---|\n")
    for sec,slug,u,n in rows: f.write(f"| {sec} | {n}.svg | alexpanozo27.github.io/redes-neuronales/c1/{slug} |\n")
print("\n".join(r[2] for r in rows))
