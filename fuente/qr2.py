import segno,os,sys
BASE='https://alexpanozo27.github.io/redes-neuronales'
SLUGS=[("10.1","neurona-biologica"),("10.2","nodo"),("10.3","algoritmos"),("10.4","fases"),("17.2","ingenieria-de-sistemas")]
OUT=sys.argv[1]; os.makedirs(OUT,exist_ok=True)
for sec,slug in SLUGS:
    q=segno.make(f"{BASE}/c2/{slug}/",error='q'); n=f"qr-{sec.replace('.','-')}-{slug}"
    q.save(f"{OUT}/{n}.svg",scale=10,border=4,dark='#0A2540',xmldecl=False,svgns=True)
    q.save(f"{OUT}/{n}.png",scale=24,border=4,dark='#0A2540')
    print(n, f"{BASE}/c2/{slug}/")
