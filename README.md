# Redes Neuronales en Mortales · Laboratorios

Laboratorios interactivos enlazados desde los códigos QR del libro *Redes Neuronales en Mortales*.

Sitio: https://alexpanozo27.github.io/redes-neuronales/

| Sección | Laboratorio | Dirección |
|---|---|---|
| 1.1 | La neurona que decide si cruzas la calle | https://alexpanozo27.github.io/redes-neuronales/c1/neurona/ |
| 1.2 | Enséñale a una neurona a llevar paraguas | https://alexpanozo27.github.io/redes-neuronales/c1/perceptron/ |
| 1.3 | ¿Cuánto aymara sabe la máquina? | https://alexpanozo27.github.io/redes-neuronales/c1/lenguas/ |
| 2.1 | Encerrado en la habitación china | https://alexpanozo27.github.io/redes-neuronales/c1/habitacion-china/ |
| 2.2 | ¿Es un gato? Reglas contra ejemplos | https://alexpanozo27.github.io/redes-neuronales/c1/gato/ |
| 2.3 | Una máquina que escribe palabra por palabra | https://alexpanozo27.github.io/redes-neuronales/c1/palabras/ |
| 2.4 | ¿Mito o realidad? | https://alexpanozo27.github.io/redes-neuronales/c1/mito-o-realidad/ |

Las páginas son HTML estático, sin servidor ni recolección de datos. **No cambies las direcciones `c1/...`: están impresas en el libro.**

## Cómo editar

Las páginas se generan desde `fuente/`: edita el laboratorio (`fuente/1-neurona.html`, etc.) o el estilo común (`common.css`, `common.js`) y luego ejecuta:

```
python3 fuente/site.py   # escribe el sitio en fuente/site/
```

Después copia `fuente/site/` a la raíz del repositorio. `fuente/qr.py` genera los QR (requiere `pip install segno`).
