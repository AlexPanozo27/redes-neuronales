// ===================================================================
// CAPÍTULO II · Secciones de Marcos Alexander Panozo Patty
//   10. La neurona artificial (10.1 a 10.4)
//   17.2 Redes neuronales aplicadas a la Ingeniería de Sistemas
//
// Usa las funciones que ya existen en main.typ: cap1-recuadro, cap1-tabla,
// cap1-qr, cap1-codigo, teoria-a-codigo y glosario-visual.
// Los QR van incrustados (SVG dentro del código) y abren los laboratorios en
// alexpanozo27.github.io/redes-neuronales/c2/...
// ===================================================================

#page(
  margin: 0pt, header: none, footer: none, background: none, fill: azul-noche,
)[
  #align(center + horizon)[
    #text(size: 18pt, tracking: 5pt, weight: "bold", fill: azul-claro)[CAPÍTULO II]
    #v(2em)
    #text(size: 38pt, weight: "bold", fill: white)[Redes Neuronales: \ la anatomía de una \ máquina que aprende]
    #v(3em)
    #line(length: 20%, stroke: 4pt + azul-acento)
  ]
]

En el Capítulo I vimos de dónde salió la idea de una máquina que piensa y cómo, después de décadas de entusiasmo y desilusión, las redes neuronales terminaron en el centro de la inteligencia artificial. Ahora toca abrir la caja. En este capítulo vamos a desarmar una red neuronal pieza por pieza, como quien desarma un reloj para entender por qué marca la hora.

Empezamos por lo más pequeño: una sola neurona artificial. Es una pieza tan sencilla que sus cuentas caben en una servilleta y, sin embargo, todo lo que viene después (las capas, el entrenamiento, los modelos que reconocen voces o escriben textos) está hecho de millones de copias de ella. Si entiendes bien esta sección, el resto del capítulo será mucho más fácil.

#cap1-recuadro("En esta sección aprenderás")[
  - Qué tomó la neurona artificial de la neurona de tu cerebro y qué dejó de lado.
  - Qué es un nodo, cuáles son sus piezas y cómo hace sus cuentas, con un ejemplo resuelto paso a paso.
  - En qué se diferencia una red neuronal de un algoritmo clásico y de otros métodos de aprendizaje automático.
  - Cuáles son las fases de un proyecto real con redes neuronales, desde la idea hasta el monitoreo.
]

= 10. La neurona artificial

== 10.1 De la neurona biológica a la neurona artificial

=== La célula que inspiró todo

Dentro de tu cabeza hay alrededor de 86 000 millones de neuronas (Azevedo et al., 2009). Ninguna de ellas, por sí sola, sabe lo que es un perro, recuerda tu cumpleaños o entiende esta frase. Cada neurona hace algo mucho más modesto: recibe señales, las junta y decide si pasa o no un mensaje a sus vecinas. Lo que llamamos pensar aparece cuando miles de millones de estas decisiones pequeñas ocurren a la vez y conectadas entre sí.

Esa observación es la semilla de las redes neuronales artificiales. Si la inteligencia del cerebro no está en una pieza especial, sino en la forma en que muchas piezas simples se conectan, quizá podamos construir algo parecido con piezas igual de simples hechas de números. Antes de ver cómo se hizo, conviene mirar con un poco más de detalle la pieza original.

=== Cómo se comunica una neurona

Una neurona típica tiene tres partes que nos interesan.

*Las dendritas* son ramificaciones cortas, parecidas a las raíces de un árbol, que reciben señales de otras neuronas. Una sola neurona puede recibir miles de conexiones (Kandel et al., 2013), así que en todo momento le está llegando información de muchas fuentes.

*El cuerpo celular*, o soma, es donde esas señales se acumulan. No todas empujan en la misma dirección: algunas excitan a la neurona, es decir, la acercan a disparar, y otras la inhiben, la calman. Lo que importa es el balance total.

*El axón* es una prolongación larga, como un cable, por donde viaja la respuesta. En sus extremos se conecta con las dendritas de otras neuronas. Ese punto de contacto, donde una neurona le pasa el mensaje a otra, se llama *sinapsis*.

Lo más llamativo es cómo decide la neurona. Si la suma de excitaciones e inhibiciones supera cierto nivel, se produce un impulso eléctrico que recorre el axón. Si no lo supera, no pasa nada. No hay medio impulso: o dispara o no dispara. Los neurocientíficos llaman a esto la ley del *todo o nada*, y es la idea que McCulloch y Pitts copiaron en 1943 con su neurona de umbral, que conociste en la sección 1.1.

#cap1-recuadro("Una analogía para no olvidarlo")[
  Imagina una reunión de vecinos que debe decidir si se arregla la calle. Cada vecino opina (las dendritas reciben señales). Algunos votos pesan más, porque esa persona sabe de construcción, y otros pesan menos (la fuerza de cada sinapsis). La presidenta suma los votos (el cuerpo celular) y, si el apoyo pasa de cierto número, se anuncia la obra a todo el barrio (el impulso que viaja por el axón).
]

=== Cómo aprende el cerebro

Si las neuronas solo sumaran y dispararan, el cerebro sería una calculadora fija. Lo que lo vuelve capaz de aprender es que las sinapsis cambian. Una conexión que se usa mucho se vuelve más fuerte y una que casi no se usa se debilita. A esa capacidad de cambio se la llama *plasticidad sináptica*.

En 1949, el psicólogo canadiense Donald Hebb propuso una regla que hoy se resume con una frase fácil de recordar: las neuronas que se activan juntas se conectan más fuerte (Hebb, 1949). Si cada vez que ves nubes negras luego llueve, las neuronas que representan «nubes negras» y las que representan «lluvia» se activan juntas una y otra vez, y la conexión entre ellas se refuerza. Con el tiempo, ver nubes negras basta para que pienses en lluvia.

Aquí está la clave de todo el capítulo: *aprender es cambiar la fuerza de las conexiones*. Cuando una red neuronal artificial aprende, eso es exactamente lo que hace, solo que con números.

=== Del cerebro a la fórmula

La neurona artificial toma esa descripción y la vuelve aritmética. La siguiente tabla muestra la traducción de cada parte.

#cap1-tabla(
  columns: (auto, 1fr, 1fr),
  inset: 7pt,
  table.header([], [*En el cerebro*], [*En la neurona artificial*]),
  [*Recibir*], [Las dendritas reciben señales de otras neuronas.], [El nodo recibe varios números llamados *entradas*: $x_1, x_2, x_3, dots$],
  [*Dar importancia*], [Cada sinapsis tiene una fuerza distinta.], [Cada entrada se multiplica por un *peso*: $w_1, w_2, w_3, dots$],
  [*Juntar*], [El cuerpo celular acumula excitación e inhibición.], [Se suman todos los productos y un número extra, el *sesgo* $b$.],
  [*Decidir*], [Si se pasa el umbral, la neurona dispara.], [Una *función de activación* transforma la suma en la respuesta.],
  [*Comunicar*], [El impulso viaja por el axón hacia otras neuronas.], [La *salida* $y$ pasa como entrada a otros nodos.],
  [*Aprender*], [Las sinapsis se fortalecen o debilitan.], [Un algoritmo ajusta los pesos y el sesgo para reducir el error.],
)

Escrito como fórmula, todo lo anterior cabe en una línea:

$ y = f(w_1 x_1 + w_2 x_2 + dots + w_n x_n + b) $

No te asustes por la notación. Dice algo que ya sabes: multiplica cada entrada por su importancia, suma todo, añade el sesgo y pasa el resultado por una función que decide la respuesta. En la sección 10.2 la vamos a usar con números concretos.

=== Lo que la neurona artificial no copia

Sería un error pensar que una red neuronal es un cerebro electrónico. La neurona artificial es una caricatura: conserva los rasgos que sirven para calcular y deja de lado casi todo lo demás. Vale la pena tener claras algunas diferencias, porque explican tanto la fuerza como los límites de estas máquinas.

- *Una neurona real es una célula viva*, con química, genes y metabolismo. La artificial es una fórmula; no hay nada biológico en ella.
- *El cerebro funciona con impulsos en el tiempo*: importa cuándo llega cada señal y con qué frecuencia dispara la neurona. La mayoría de las redes artificiales solo pasan números de una capa a la siguiente, sin ritmo ni tiempo.
- *El cerebro aprende de pocos ejemplos.* Un niño reconoce una llama después de ver dos o tres. Una red suele necesitar miles de fotos para lograrlo.
- *El cerebro gasta muy poca energía.* Todo el cerebro humano consume unos 20 vatios, menos que un foco común (Raichle y Gusnard, 2002). Entrenar un modelo grande puede consumir la electricidad de muchos hogares durante semanas.
- *No sabemos del todo cómo aprende el cerebro.* El método que usan las redes artificiales para ajustar sus pesos, la retropropagación, funciona muy bien en una computadora, pero no está claro que el cerebro haga algo equivalente (Goodfellow et al., 2016).

Por eso es mejor pensar en el cerebro como una *inspiración*, no como un plano. Los ingenieros que diseñan aviones también se inspiraron en los pájaros, pero ningún avión mueve las alas.

#cap1-recuadro("Para recordar")[
  - Una neurona biológica recibe señales por las dendritas, las acumula en el cuerpo celular y, si superan un umbral, dispara un impulso por el axón.
  - El cerebro aprende cambiando la fuerza de las sinapsis. En una red artificial, esa fuerza se convierte en un número: el peso.
  - La neurona artificial es una simplificación útil, no una copia: se inspira en el cerebro, pero funciona con aritmética.
]

#cap1-qr(bytes(```svg <svg xmlns="http://www.w3.org/2000/svg" width="490" height="490" class="segno"><path transform="scale(10)" class="qrline" stroke="#0a2540" d="M4 4.5h7m2 0h3m1 0h3m1 0h1m1 0h2m3 0h1m3 0h1m2 0h2m1 0h7m-41 1h1m5 0h1m1 0h5m1 0h1m1 0h1m1 0h2m6 0h1m1 0h1m1 0h1m3 0h1m5 0h1m-41 1h1m1 0h3m1 0h1m1 0h1m1 0h2m2 0h4m7 0h1m1 0h1m2 0h3m1 0h1m1 0h3m1 0h1m-41 1h1m1 0h3m1 0h1m2 0h1m10 0h1m1 0h1m1 0h1m4 0h1m4 0h1m1 0h3m1 0h1m-41 1h1m1 0h3m1 0h1m4 0h14m1 0h4m1 0h2m1 0h1m1 0h3m1 0h1m-41 1h1m5 0h1m3 0h1m1 0h1m1 0h3m1 0h2m4 0h2m2 0h1m2 0h1m2 0h1m5 0h1m-41 1h7m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h7m-32 1h2m10 0h1m1 0h2m2 0h1m1 0h4m-32 1h3m1 0h2m2 0h1m1 0h1m2 0h1m3 0h2m1 0h1m4 0h1m1 0h4m6 0h2m-40 1h1m2 0h3m1 0h2m1 0h1m1 0h2m1 0h2m3 0h5m3 0h9m1 0h3m-38 1h4m2 0h1m2 0h2m3 0h2m2 0h1m8 0h1m3 0h1m1 0h1m1 0h2m-40 1h1m1 0h1m1 0h1m2 0h3m2 0h2m1 0h2m2 0h2m1 0h1m1 0h3m1 0h1m3 0h5m-35 1h2m2 0h1m1 0h2m1 0h1m1 0h2m2 0h4m4 0h3m1 0h1m1 0h1m3 0h1m1 0h2m1 0h1m-40 1h3m1 0h1m2 0h3m1 0h2m2 0h2m1 0h2m1 0h2m1 0h2m2 0h1m1 0h1m2 0h1m2 0h2m1 0h1m-39 1h2m1 0h5m3 0h3m2 0h3m3 0h1m1 0h1m2 0h1m1 0h2m1 0h2m2 0h3m-41 1h6m4 0h1m1 0h1m1 0h3m2 0h1m2 0h1m1 0h1m3 0h1m2 0h2m1 0h1m4 0h2m-40 1h1m1 0h2m1 0h2m3 0h3m1 0h1m1 0h1m2 0h2m1 0h1m1 0h1m1 0h1m3 0h2m3 0h1m2 0h2m-40 1h2m1 0h1m2 0h2m1 0h1m4 0h1m1 0h1m3 0h4m2 0h3m2 0h2m1 0h1m3 0h1m-39 1h1m1 0h5m2 0h1m2 0h1m2 0h1m1 0h1m1 0h2m2 0h4m2 0h1m5 0h2m1 0h1m-37 1h2m4 0h1m1 0h2m2 0h3m2 0h1m1 0h1m2 0h3m1 0h2m4 0h1m1 0h2m1 0h1m-40 1h1m1 0h2m1 0h1m1 0h1m5 0h1m2 0h3m1 0h1m3 0h2m2 0h2m2 0h2m1 0h1m1 0h1m1 0h1m-41 1h2m1 0h1m7 0h1m2 0h2m3 0h3m1 0h3m2 0h9m2 0h2m-40 1h11m3 0h2m2 0h2m2 0h3m2 0h3m2 0h7m-39 1h2m5 0h2m1 0h4m2 0h7m1 0h1m1 0h1m3 0h2m4 0h1m1 0h2m-40 1h1m1 0h1m2 0h1m3 0h1m1 0h1m1 0h2m4 0h3m1 0h3m1 0h2m8 0h1m-39 1h1m1 0h1m2 0h1m5 0h1m2 0h1m1 0h1m1 0h4m2 0h1m1 0h3m2 0h2m1 0h1m2 0h2m1 0h1m-41 1h3m2 0h2m1 0h2m2 0h4m1 0h1m1 0h1m5 0h2m1 0h1m2 0h3m2 0h2m1 0h2m-41 1h1m4 0h1m4 0h4m2 0h2m2 0h5m2 0h1m3 0h2m1 0h1m1 0h2m2 0h1m-41 1h1m5 0h3m2 0h2m3 0h1m1 0h1m1 0h3m2 0h1m1 0h1m2 0h4m1 0h3m1 0h2m-40 1h1m1 0h2m4 0h4m7 0h2m2 0h2m1 0h3m2 0h1m2 0h1m2 0h1m-39 1h1m3 0h1m1 0h4m2 0h1m2 0h1m1 0h8m1 0h4m3 0h3m2 0h1m-37 1h1m2 0h1m1 0h2m3 0h1m3 0h2m2 0h3m1 0h1m4 0h2m3 0h1m2 0h3m-39 1h2m3 0h6m4 0h5m1 0h3m1 0h1m2 0h2m1 0h8m-32 1h1m1 0h1m3 0h5m4 0h1m2 0h1m3 0h1m1 0h1m3 0h2m2 0h1m-41 1h7m4 0h3m3 0h2m1 0h1m2 0h2m1 0h1m1 0h1m2 0h2m1 0h1m1 0h3m-39 1h1m5 0h1m1 0h2m1 0h1m6 0h2m1 0h1m2 0h5m1 0h1m1 0h1m3 0h1m2 0h1m-40 1h1m1 0h3m1 0h1m3 0h2m2 0h2m2 0h1m2 0h2m4 0h1m1 0h1m2 0h7m1 0h1m-41 1h1m1 0h3m1 0h1m1 0h1m4 0h1m1 0h1m3 0h2m3 0h2m1 0h1m1 0h1m1 0h2m3 0h2m-38 1h1m1 0h3m1 0h1m1 0h1m4 0h1m2 0h2m1 0h3m2 0h1m1 0h1m3 0h2m3 0h1m3 0h2m-41 1h1m5 0h1m1 0h1m5 0h5m7 0h1m1 0h1m2 0h4m1 0h2m1 0h1m-40 1h7m2 0h4m1 0h6m3 0h3m1 0h2m1 0h3m6 0h1"/></svg>```.text), "alexpanozo27.github.io/redes-neuronales/c2/neurona-biologica", [Laboratorio 10.1: toca cada parte de una neurona de tu cerebro y descubre en qué se convirtió dentro de la máquina.], disponible: true)

== 10.2 Qué es un nodo y por qué es la unidad mínima de una red

=== Neurona, nodo, unidad: tres nombres para lo mismo

En los libros y en los programas vas a encontrar varios nombres para la misma pieza: neurona artificial, nodo, unidad o perceptrón, en honor a la red de Rosenblatt (1958). En este libro usamos *nodo* cuando hablamos de la pieza dentro de una red, porque la palabra recuerda que es un punto de conexión, como un nudo en una red de pescar. Lo que ocurre en ese punto es siempre lo mismo: entran números, se combinan y sale un número.

=== Las piezas de un nodo

Un nodo tiene cinco piezas. Las vamos a ver con un ejemplo que nos acompañará en toda la sección: un nodo que decide si conviene *salir a correr esta tarde*.

*1. Las entradas ($x$).* Son los datos que el nodo mira. En nuestro ejemplo usaremos tres, cada una con un valor entre 0 y 1:
- $x_1$: qué tanto sol hay (0 es nublado y 1, sol pleno).
- $x_2$: cuánto tiempo libre tienes (0 es nada y 1, toda la tarde).
- $x_3$: qué tan cansado estás (0 es descansado y 1, agotado).

En una red real las entradas pueden ser cualquier cosa que se pueda expresar con números: el brillo de cada píxel de una foto, la temperatura de un día o la salida de otros nodos.

*2. Los pesos ($w$).* Cada entrada tiene su peso, un número que dice cuánto influye en la decisión. Un peso positivo empuja a favor, uno negativo empuja en contra y un peso cercano a cero hace que esa entrada casi no importe. Para nuestro corredor elegimos $w_1 = 1.5$ (el sol anima), $w_2 = 2$ (el tiempo libre anima todavía más) y $w_3 = -2$ (el cansancio desanima).

*3. El sesgo ($b$).* Es un número que se suma al final, aunque todas las entradas valgan cero. Representa la inclinación de base del nodo, lo que «piensa» antes de mirar los datos. Una persona a la que le encanta correr tendría un sesgo positivo; una que prefiere el sillón, uno negativo. Elegimos $b = -1$: nuestro corredor necesita algo de motivación.

*4. La suma ponderada ($z$).* El nodo multiplica cada entrada por su peso, suma los resultados y añade el sesgo:

$ z = w_1 x_1 + w_2 x_2 + w_3 x_3 + b $

*5. La función de activación ($f$).* Toma la suma $z$ y la convierte en la respuesta final $y = f(z)$. La más sencilla es el *escalón*: responde 1 si $z >= 0$ y 0 si $z < 0$. Es la versión moderna del umbral de McCulloch y Pitts. Existen otras, como la sigmoide o ReLU, que dan respuestas graduales; las estudiaremos a fondo en la sección 12.6.

=== Ejemplo resuelto: ¿salgo a correr?

Supongamos que hoy hay bastante sol ($x_1 = 0.8$), tienes media tarde libre ($x_2 = 0.5$) y estás un poco cansado ($x_3 = 0.3$).

*Paso 1. Multiplicar cada entrada por su peso.*

$ w_1 x_1 = 1.5 times 0.8 = 1.2 quad quad w_2 x_2 = 2 times 0.5 = 1.0 quad quad w_3 x_3 = -2 times 0.3 = -0.6 $

*Paso 2. Sumar y añadir el sesgo.*

$ z = 1.2 + 1.0 - 0.6 - 1 = 0.6 $

*Paso 3. Aplicar la función de activación.* Como $z = 0.6$ es mayor o igual que cero, el escalón responde $y = 1$: el nodo dice que sí, sal a correr.

Ahora cambiemos un solo dato. Imagina que llegaste agotado ($x_3 = 1$). El tercer producto pasa a ser $-2 times 1 = -2$ y la suma queda $z = 1.2 + 1.0 - 2 - 1 = -0.8$. Como es negativa, el escalón responde $y = 0$: hoy toca descansar. Con los mismos pesos, otros datos producen otra decisión, que es justamente lo que esperamos de un buen criterio.

#cap1-recuadro("Prueba tú")[
  Con los mismos pesos y sesgo, ¿qué decide el nodo si está nublado ($x_1 = 0$), tienes toda la tarde libre ($x_2 = 1$) y no estás nada cansado ($x_3 = 0$)?

  _Solución:_ $z = 0 + 2 + 0 - 1 = 1$. Como $z >= 0$, la salida es 1: aunque esté nublado, el tiempo libre pesa lo suficiente para salir.
]

=== ¿Quién elige los pesos?

En el ejemplo elegimos los pesos a mano, como si conociéramos muy bien al corredor. En una red neuronal real nadie los escribe. Se empieza con pesos al azar y se le muestran a la red muchos ejemplos con su respuesta correcta: tardes en que la persona salió a correr y tardes en que no. Cada vez que la red se equivoca, un algoritmo corrige un poco los pesos en la dirección que habría reducido el error. Después de miles de correcciones, los pesos terminan guardando el criterio que estaba escondido en los ejemplos.

Por eso a los pesos se los llama a veces la *memoria* de la red: todo lo que aprendió está guardado ahí, repartido en números. El proceso de corrección es el entrenamiento, y lo explica en detalle la sección 13.

#teoria-a-codigo(
  "un nodo en siete líneas de Python",
  [El mismo cálculo del ejemplo, escrito como lo haría un programador. No necesitas instalar nada especial: funciona en cualquier Python o en Google Colab.],
  ```python
  def escalon(z):
      return 1 if z >= 0 else 0

  def nodo(entradas, pesos, sesgo):
      z = sum(x * w for x, w in zip(entradas, pesos)) + sesgo
      return escalon(z)

  print(nodo([0.8, 0.5, 0.3], [1.5, 2, -2], -1))   # muestra 1
  print(nodo([0.8, 0.5, 1.0], [1.5, 2, -2], -1))   # muestra 0
  ```,
  [La función `escalon` devuelve 1 si la suma es mayor o igual que cero. La función `nodo` multiplica cada entrada por su peso con `zip`, suma todo con `sum` y añade el sesgo. Las dos últimas líneas repiten los dos casos del ejemplo: con cansancio 0.3 sale 1 y con cansancio 1.0 sale 0.]
)

=== Por qué el nodo es la unidad mínima

Decimos que el nodo es la *unidad mínima* de una red porque es la pieza más pequeña que todavía hace un cálculo completo: recibe, combina y decide. Si lo partes, lo que queda (un peso suelto o una suma sin activación) ya no toma ninguna decisión. Es como una letra en un texto o un ladrillo en una casa: una letra sola no dice mucho y un ladrillo solo no es una pared, pero todo lo demás se construye juntándolos.

Esta idea tiene una consecuencia práctica muy importante. Como todos los nodos hacen la misma operación, una red neuronal es, en el fondo, la misma cuenta repetida muchísimas veces. Las tarjetas gráficas (GPU) son excelentes justamente para eso, para hacer miles de multiplicaciones y sumas iguales al mismo tiempo. Por eso fueron decisivas en la revolución de 2012 que vimos en la sección 1.2.

=== Un nodo solo hace poco; muchos hacen mucho

Un nodo aislado tiene un límite serio. Con dos entradas, lo único que puede hacer es trazar una línea recta y decir «de un lado, sí; del otro, no». Ya vimos en la sección 1.2 que eso no alcanza para un problema tan simple como el interruptor de escalera (XOR).

La solución es conectar nodos en *capas*: la salida de unos se convierte en la entrada de otros. Cada capa combina lo que encontró la anterior y así la red puede trazar fronteras curvas y muy complicadas. Se ha demostrado que una red con al menos una capa oculta y suficientes nodos puede aproximar, con la precisión que se quiera, casi cualquier relación entre entradas y salidas (Cybenko, 1989; Hornik et al., 1989). Este resultado se conoce como el *teorema de aproximación universal* y explica por qué piezas tan simples, bien conectadas, resultan tan poderosas. Cómo se organizan esas capas es el tema de la sección 12.

#cap1-recuadro("Ejercicio resuelto: contar las piezas de una red")[
  Una red clásica para reconocer dígitos escritos a mano recibe imágenes de 28 × 28 píxeles, es decir, 784 entradas. Tiene una capa oculta de 128 nodos y una capa de salida de 10 nodos (uno por cada dígito del 0 al 9). ¿Cuántos números tiene que aprender?

  _Solución:_ cada nodo de la capa oculta tiene un peso por cada una de las 784 entradas, más su sesgo: 128 × 784 + 128 = 100 480. Cada nodo de salida tiene un peso por cada uno de los 128 nodos ocultos, más su sesgo: 10 × 128 + 10 = 1 290. En total, 100 480 + 1 290 = 101 770 números. Una red pequeña ya necesita más de cien mil pesos; los grandes modelos de lenguaje tienen miles de millones.
]

#cap1-recuadro("Para recordar")[
  - Un nodo recibe entradas, multiplica cada una por su peso, suma todo con el sesgo y aplica una función de activación: $y = f(sum w_i x_i + b)$.
  - Los pesos y el sesgo no se escriben a mano: la red los encuentra durante el entrenamiento, y en ellos queda guardado lo que aprendió.
  - Un nodo solo traza fronteras simples. La potencia de una red viene de conectar muchos nodos en capas.
]

#cap1-qr(bytes(```svg <svg xmlns="http://www.w3.org/2000/svg" width="450" height="450" class="segno"><path transform="scale(10)" class="qrline" stroke="#0a2540" d="M4 4.5h7m1 0h3m1 0h1m2 0h1m2 0h2m4 0h2m2 0h1m1 0h7m-37 1h1m5 0h1m3 0h1m2 0h3m1 0h5m2 0h1m1 0h3m1 0h1m5 0h1m-37 1h1m1 0h3m1 0h1m2 0h2m1 0h1m6 0h1m1 0h1m2 0h1m1 0h1m1 0h1m1 0h1m1 0h3m1 0h1m-37 1h1m1 0h3m1 0h1m3 0h1m1 0h4m1 0h2m3 0h1m1 0h4m2 0h1m1 0h3m1 0h1m-37 1h1m1 0h3m1 0h1m1 0h4m1 0h1m2 0h2m3 0h3m1 0h1m4 0h1m1 0h3m1 0h1m-37 1h1m5 0h1m1 0h1m4 0h1m2 0h1m1 0h3m3 0h5m1 0h1m5 0h1m-37 1h7m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h7m-26 1h4m1 0h1m1 0h1m1 0h2m1 0h2m1 0h1m1 0h1m-28 1h7m1 0h2m4 0h1m4 0h1m3 0h3m4 0h2m3 0h1m-35 1h3m3 0h3m2 0h3m1 0h1m2 0h1m2 0h1m1 0h1m2 0h2m-28 1h3m1 0h2m7 0h3m2 0h1m1 0h1m2 0h3m2 0h3m3 0h1m-36 1h1m1 0h2m2 0h1m1 0h1m1 0h1m1 0h3m5 0h2m3 0h1m1 0h1m1 0h1m4 0h1m-35 1h3m1 0h2m2 0h2m3 0h1m1 0h2m1 0h2m1 0h1m2 0h2m2 0h2m1 0h1m1 0h2m-34 1h1m2 0h1m3 0h2m6 0h2m1 0h1m2 0h1m1 0h1m3 0h1m1 0h1m1 0h2m-35 1h1m5 0h2m1 0h1m1 0h1m1 0h2m1 0h2m4 0h1m4 0h2m1 0h2m1 0h1m1 0h2m-36 1h2m1 0h2m2 0h1m3 0h2m1 0h1m1 0h1m1 0h2m5 0h1m4 0h1m-28 1h1m1 0h9m2 0h1m1 0h4m1 0h4m2 0h3m1 0h2m-35 1h1m1 0h3m1 0h1m5 0h1m1 0h1m1 0h1m1 0h3m2 0h3m1 0h2m4 0h1m-34 1h3m1 0h4m1 0h2m1 0h1m4 0h4m3 0h3m1 0h4m1 0h3m-36 1h1m1 0h1m3 0h4m1 0h1m1 0h1m2 0h2m2 0h1m1 0h1m4 0h1m1 0h3m3 0h1m-33 1h3m2 0h3m2 0h1m1 0h3m1 0h1m1 0h2m1 0h2m2 0h4m1 0h1m-34 1h3m3 0h1m2 0h1m3 0h3m1 0h1m1 0h1m2 0h1m7 0h1m2 0h1m-33 1h7m1 0h1m1 0h1m2 0h1m3 0h1m2 0h1m3 0h2m2 0h1m3 0h3m-37 1h2m1 0h1m4 0h4m1 0h1m1 0h1m1 0h2m1 0h2m9 0h1m4 0h1m-35 1h3m1 0h3m3 0h1m1 0h3m1 0h1m1 0h1m1 0h1m2 0h2m3 0h1m1 0h1m1 0h2m-36 1h1m3 0h1m2 0h2m2 0h1m1 0h1m4 0h1m4 0h1m4 0h1m2 0h1m1 0h1m-34 1h1m4 0h9m1 0h6m1 0h1m1 0h1m2 0h2m1 0h3m1 0h3m-37 1h1m2 0h1m6 0h1m1 0h1m2 0h3m3 0h1m2 0h1m1 0h1m1 0h2m1 0h3m1 0h2m-37 1h1m1 0h1m1 0h1m1 0h3m2 0h3m3 0h3m2 0h5m1 0h7m-27 1h1m2 0h3m1 0h2m1 0h1m2 0h1m1 0h1m4 0h1m3 0h1m-33 1h7m1 0h2m1 0h2m2 0h3m3 0h1m2 0h1m1 0h1m1 0h1m1 0h1m1 0h2m1 0h2m-37 1h1m5 0h1m1 0h1m3 0h4m2 0h5m5 0h1m3 0h1m2 0h2m-37 1h1m1 0h3m1 0h1m1 0h3m1 0h1m2 0h1m2 0h1m2 0h1m1 0h10m1 0h1m1 0h1m-37 1h1m1 0h3m1 0h1m1 0h1m2 0h4m1 0h1m1 0h1m1 0h5m5 0h1m1 0h4m-36 1h1m1 0h3m1 0h1m1 0h1m1 0h2m2 0h1m2 0h1m1 0h1m1 0h1m4 0h1m2 0h1m1 0h1m1 0h2m1 0h1m-37 1h1m5 0h1m1 0h1m2 0h1m3 0h1m1 0h7m2 0h5m1 0h1m3 0h1m-37 1h7m2 0h1m2 0h1m5 0h2m2 0h2m1 0h3m1 0h1m3 0h4"/></svg>```.text), "alexpanozo27.github.io/redes-neuronales/c2/nodo", [Laboratorio 10.2: arma tu propio nodo, mueve pesos, sesgo y activación, y mira cómo cambia la cuenta en vivo.], disponible: true)

== 10.3 Qué distingue a un algoritmo de red neuronal de otros algoritmos

=== Primero: ¿qué es un algoritmo?

Un *algoritmo* es una secuencia ordenada de pasos que resuelve un problema. Una receta de cocina es un algoritmo, y también lo es el método que aprendiste en la escuela para dividir números grandes. En informática, casi todo lo que hace una computadora sigue algoritmos: ordenar una lista, buscar un nombre en una agenda, calcular la ruta más corta entre dos calles.

Las redes neuronales también son algoritmos, pero de un tipo especial. La diferencia no está en que usen matemáticas más difíciles, sino en *quién escribe las reglas*.

=== Programar reglas o aprender de ejemplos

En la programación tradicional, una persona estudia el problema, descubre las reglas y las escribe en un programa. La computadora recibe datos, aplica esas reglas y entrega respuestas. Si quieres calcular el sueldo líquido de un trabajador, escribes las fórmulas de los descuentos, y el programa las aplica a cada sueldo.

Con una red neuronal el camino se invierte. Le damos a la computadora datos *y* las respuestas correctas, y el entrenamiento encuentra por sí solo las reglas que conectan unos con otras (Chollet, 2021). Nadie le dice a la red cómo se ve una hoja de papa enferma: se le muestran miles de fotos de hojas, cada una marcada como «sana» o «enferma», y la red ajusta sus pesos hasta reconocer la diferencia.

#align(center)[
  #block(breakable: false, above: 1.2em, below: 1.2em)[
    #set text(size: 10pt)
    #set par(first-line-indent: 0em, justify: false)
    #let caja(t, c) = box(stroke: 1.5pt + c, inset: 7pt, fill: white)[#t]
    #grid(
      columns: (auto, auto, auto, auto, auto),
      column-gutter: 8pt, row-gutter: 14pt, align: horizon,
      text(weight: "bold", fill: azul-noche)[Programación \ tradicional], caja([Datos + Reglas], azul-acento), [#sym.arrow.r], caja([Computadora], azul-noche), [#sym.arrow.r #h(4pt) Respuestas],
      text(weight: "bold", fill: azul-noche)[Red neuronal], caja([Datos + Respuestas], azul-acento), [#sym.arrow.r], caja([Entrenamiento], azul-noche), [#sym.arrow.r #h(4pt) Reglas (pesos)],
    )
  ]
]

Esta inversión es la idea central del aprendizaje automático. Tom Mitchell la resumió con una definición muy citada: se dice que un programa aprende de la experiencia cuando su desempeño en una tarea mejora a medida que acumula esa experiencia (Mitchell, 1997). La red no recibe instrucciones; recibe experiencia.

=== Seis rasgos de un algoritmo de red neuronal

¿Qué hace diferente a una red neuronal de un algoritmo clásico? Estos son sus rasgos más importantes.

*1. Aprende de ejemplos.* Sus reglas no se escriben, se ajustan. Esto le permite resolver problemas que nadie sabe describir paso a paso, como reconocer una voz o una cara.

*2. Su conocimiento está repartido.* En un programa tradicional puedes señalar la línea donde está cada regla. En una red, lo aprendido está disperso en miles o millones de pesos, y ninguno significa algo por sí solo. Es el carácter *conexionista* que vimos en la sección 2.2.

*3. Aproxima, no garantiza.* Un algoritmo de ordenamiento siempre ordena bien. Una red neuronal acierta con cierta probabilidad: puede tener un 95 % de aciertos, pero nunca un 100 % asegurado. Por eso siempre se mide qué tan bien funciona con datos nuevos (sección 14).

*4. Generaliza.* Si aprendió bien, puede responder sobre casos que nunca vio, siempre que se parezcan a los de su entrenamiento. Una red entrenada con fotos de hojas de papa de Cochabamba debería reconocer el tizón en una foto tomada en Potosí. Si las condiciones son muy distintas, puede fallar.

*5. Depende de los datos y del cómputo.* Sin muchos ejemplos de buena calidad, la red no aprende, y entrenarla exige mucha capacidad de cálculo. Un algoritmo clásico, en cambio, funciona desde el primer día sin un solo ejemplo.

*6. Es difícil de explicar.* Cuando una red decide, no es fácil saber por qué. Por eso se habla de *caja negra*. Existen técnicas para asomarse adentro, pero ninguna da la claridad de una regla escrita.

=== ¿Y frente a otros algoritmos que también aprenden?

Las redes neuronales no son el único método de aprendizaje automático. Existen otros que también aprenden de ejemplos, como la *regresión lineal*, que busca la recta que mejor se ajusta a los datos; los *árboles de decisión*, que aprenden una serie de preguntas del tipo «¿la temperatura es mayor que 20 grados?»; o el método de los *k vecinos más cercanos*, que clasifica un caso nuevo mirando a los ejemplos que más se le parecen. Los veremos con más detalle en la sección 6.

La diferencia más importante es esta: casi todos esos métodos necesitan que una persona prepare antes las *características* de los datos. Para clasificar fotos de hojas con un árbol de decisión, alguien tendría que medir primero el color promedio, el tamaño de las manchas o la forma del borde. Una red neuronal profunda puede recibir los píxeles en bruto y descubrir sola qué características importan: las primeras capas aprenden bordes y manchas, las siguientes combinan esas piezas en formas y las últimas reconocen la enfermedad (LeCun et al., 2015). A esto se lo llama *aprendizaje de representaciones*, y es la razón por la que las redes dominan en imágenes, sonido y lenguaje.

#cap1-tabla(
  columns: (auto, 1fr, 1fr, 1fr),
  inset: 6pt,
  table.header([], [*Algoritmo clásico*], [*Otros métodos de aprendizaje*], [*Red neuronal*]),
  [*Quién pone las reglas*], [Una persona], [Se aprenden de los datos], [Se aprenden de los datos],
  [*Quién elige las características*], [Una persona], [Normalmente, una persona], [La propia red, a partir de datos en bruto],
  [*Datos que necesita*], [Ninguno para funcionar], [Cientos o miles de ejemplos], [Miles o millones de ejemplos],
  [*Exactitud*], [Exacta, si las reglas son correctas], [Aproximada], [Aproximada, muy alta en imágenes, voz y texto],
  [*Explicabilidad*], [Total], [Media o alta (por ejemplo, un árbol se puede leer)], [Baja: caja negra],
  [*Ejemplo*], [Calcular un sueldo líquido], [Predecir el precio de una casa con una tabla de datos], [Reconocer tizón en la foto de una hoja],
)

=== Cuándo no usar una red neuronal

Que las redes estén de moda no significa que sirvan para todo. Una buena regla práctica es preguntarse: *¿sé escribir la receta exacta?* Si la respuesta es sí, un algoritmo clásico casi siempre gana: es más barato, más rápido, no necesita datos y se puede explicar línea por línea. Calcular impuestos, ordenar una lista o encontrar el camino más corto en un mapa (el algoritmo de Dijkstra lo resuelve desde 1959) son problemas de receta.

La red neuronal vale la pena cuando el patrón existe, pero no se puede escribir: reconocer, escuchar, traducir, predecir a partir de muchos factores combinados. Y aun así, solo si hay suficientes datos para aprenderlo. En la práctica, los sistemas reales mezclan ambas cosas: un banco puede usar una red para detectar compras sospechosas y reglas escritas para decidir qué hacer con ellas.

#cap1-recuadro("Ejercicio resuelto: ¿receta o ejemplos?")[
  Decide qué herramienta usarías en cada caso.

  + Verificar si la contraseña que escribió un usuario es la correcta.
  + Convertir en texto un audio de WhatsApp.
  + Ordenar alfabéticamente la lista de estudiantes de un curso.
  + Estimar la cosecha de quinua de una parcela a partir de fotos satelitales y datos del clima.

  _Soluciones:_ (1) algoritmo clásico: la comparación debe ser exacta y no se acepta un «se parece bastante»; (2) red neuronal: cada persona habla distinto y nadie puede escribir reglas para todas las voces; (3) algoritmo clásico: ordenar es un problema resuelto con métodos exactos y rápidos; (4) red neuronal u otro método de aprendizaje: muchos factores se combinan de formas que no conocemos de antemano, siempre que haya datos de campañas anteriores.
]

#cap1-recuadro("Para recordar")[
  - Un algoritmo clásico sigue reglas escritas por personas; una red neuronal aprende sus reglas a partir de ejemplos con su respuesta.
  - A diferencia de otros métodos de aprendizaje, la red puede descubrir sola qué características de los datos importan.
  - Las redes aproximan, necesitan muchos datos y son difíciles de explicar. Si la receta se puede escribir, conviene un algoritmo clásico.
]

#cap1-qr(bytes(```svg <svg xmlns="http://www.w3.org/2000/svg" width="490" height="490" class="segno"><path transform="scale(10)" class="qrline" stroke="#0a2540" d="M4 4.5h7m1 0h1m2 0h1m1 0h1m4 0h2m3 0h1m2 0h1m2 0h1m4 0h7m-41 1h1m5 0h1m1 0h2m1 0h1m1 0h3m1 0h2m2 0h2m2 0h2m1 0h1m1 0h1m1 0h1m1 0h1m5 0h1m-41 1h1m1 0h3m1 0h1m7 0h2m1 0h1m1 0h3m1 0h3m2 0h1m3 0h1m1 0h1m1 0h3m1 0h1m-41 1h1m1 0h3m1 0h1m9 0h4m1 0h1m1 0h2m2 0h2m1 0h1m1 0h1m1 0h1m1 0h3m1 0h1m-41 1h1m1 0h3m1 0h1m2 0h2m2 0h1m2 0h1m2 0h1m8 0h1m2 0h1m2 0h1m1 0h3m1 0h1m-41 1h1m5 0h1m6 0h3m2 0h1m2 0h1m8 0h1m3 0h1m5 0h1m-41 1h7m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h7m-32 1h6m2 0h1m2 0h3m3 0h2m3 0h1m-31 1h1m4 0h4m1 0h1m3 0h2m1 0h1m1 0h2m3 0h3m1 0h1m3 0h1m5 0h2m-41 1h5m2 0h1m1 0h1m2 0h3m3 0h1m3 0h3m1 0h2m1 0h3m3 0h2m2 0h1m-37 1h1m1 0h2m4 0h4m1 0h1m2 0h1m3 0h1m2 0h2m1 0h1m2 0h2m1 0h1m-36 1h3m1 0h1m3 0h5m2 0h2m1 0h1m1 0h1m2 0h2m1 0h1m3 0h6m1 0h1m1 0h1m-37 1h1m1 0h2m2 0h2m1 0h1m2 0h1m2 0h3m1 0h1m1 0h1m2 0h1m4 0h3m4 0h1m-39 1h1m1 0h1m1 0h1m4 0h1m1 0h1m1 0h1m3 0h1m1 0h1m1 0h1m7 0h1m1 0h1m1 0h4m2 0h1m-40 1h2m1 0h3m1 0h1m1 0h1m1 0h4m1 0h2m3 0h3m2 0h5m1 0h1m1 0h4m-35 1h1m3 0h2m2 0h1m1 0h3m3 0h2m1 0h1m4 0h1m2 0h1m1 0h1m4 0h1m-37 1h2m1 0h3m6 0h1m1 0h2m4 0h2m1 0h3m1 0h3m1 0h1m1 0h1m2 0h1m1 0h1m-41 1h1m1 0h2m4 0h1m1 0h1m4 0h4m2 0h3m3 0h1m1 0h9m1 0h2m-39 1h2m2 0h1m1 0h1m2 0h1m2 0h1m1 0h1m4 0h3m1 0h4m2 0h2m1 0h3m1 0h3m-41 1h1m1 0h1m1 0h2m2 0h4m3 0h1m2 0h1m1 0h4m2 0h2m1 0h2m1 0h1m3 0h2m2 0h1m-41 1h1m1 0h1m3 0h1m4 0h2m1 0h3m1 0h2m3 0h2m2 0h2m2 0h1m3 0h1m1 0h3m-39 1h1m1 0h2m2 0h1m3 0h1m4 0h4m2 0h4m1 0h1m1 0h3m3 0h4m-39 1h1m2 0h1m2 0h2m1 0h2m1 0h2m2 0h4m1 0h2m2 0h4m3 0h1m1 0h2m-36 1h1m1 0h3m6 0h1m4 0h1m3 0h1m1 0h3m2 0h2m1 0h1m1 0h1m1 0h2m1 0h1m2 0h1m-39 1h1m2 0h3m1 0h3m3 0h3m1 0h1m2 0h3m6 0h2m1 0h2m1 0h1m-36 1h3m5 0h1m1 0h1m1 0h1m2 0h3m1 0h3m3 0h5m2 0h4m2 0h1m-41 1h1m2 0h1m2 0h2m2 0h2m2 0h2m1 0h2m1 0h3m1 0h1m1 0h2m2 0h1m1 0h1m1 0h1m-35 1h4m1 0h1m3 0h1m1 0h1m1 0h3m1 0h1m1 0h1m3 0h2m1 0h1m1 0h1m2 0h1m1 0h1m2 0h3m-39 1h1m2 0h2m1 0h2m1 0h1m1 0h1m2 0h2m1 0h1m1 0h1m2 0h2m1 0h2m2 0h1m1 0h1m1 0h1m3 0h3m-40 1h2m1 0h1m1 0h1m1 0h1m1 0h1m5 0h8m1 0h2m2 0h3m4 0h4m1 0h1m-41 1h3m3 0h1m5 0h2m1 0h1m3 0h2m1 0h2m1 0h1m2 0h1m2 0h3m3 0h1m2 0h1m-41 1h1m3 0h2m1 0h1m2 0h5m1 0h2m1 0h1m2 0h1m1 0h1m2 0h2m5 0h4m1 0h1m-40 1h1m1 0h5m1 0h1m1 0h8m1 0h1m2 0h1m1 0h3m1 0h2m2 0h5m1 0h1m1 0h1m-33 1h1m3 0h1m7 0h1m2 0h1m1 0h4m1 0h1m1 0h1m3 0h4m-40 1h7m1 0h1m1 0h1m1 0h4m2 0h1m2 0h2m2 0h4m1 0h3m1 0h1m1 0h2m1 0h1m-40 1h1m5 0h1m2 0h4m1 0h1m1 0h3m1 0h1m2 0h1m1 0h1m1 0h1m3 0h2m3 0h2m1 0h2m-41 1h1m1 0h3m1 0h1m6 0h6m1 0h2m1 0h1m1 0h1m1 0h10m-37 1h1m1 0h3m1 0h1m4 0h2m1 0h2m1 0h3m2 0h2m1 0h1m1 0h1m3 0h1m3 0h1m1 0h4m-41 1h1m1 0h3m1 0h1m3 0h1m1 0h1m2 0h1m4 0h1m4 0h4m4 0h5m1 0h1m-40 1h1m5 0h1m1 0h3m2 0h1m4 0h1m1 0h1m6 0h1m3 0h1m4 0h3m1 0h1m-41 1h7m5 0h2m5 0h1m1 0h1m3 0h2m1 0h2m1 0h1m1 0h1m1 0h2m1 0h1"/></svg>```.text), "alexpanozo27.github.io/redes-neuronales/c2/algoritmos", [Laboratorio 10.3: diez casos de la vida real; en cada uno, decide si usarías un algoritmo clásico o una red neuronal.], disponible: true)

== 10.4 Fases de un proyecto de red neuronal

=== Más que entrenar una red

Cuando se habla de inteligencia artificial, casi toda la atención se la lleva el momento del entrenamiento, como si un proyecto consistiera en apretar un botón y esperar. En la práctica, entrenar es una fase entre varias, y muchas veces ni siquiera es la que más tiempo ocupa. Un estudio de ingenieros de Google mostró que, en un sistema real de aprendizaje automático, el código del modelo es una parte pequeña rodeada de mucho más trabajo: reunir y verificar datos, configurar, desplegar y vigilar (Sculley et al., 2015).

Para ordenar ese trabajo, la industria usa desde hace años modelos de proceso como CRISP-DM (Chapman et al., 2000). En este libro lo organizamos en ocho fases, y cada una se desarrolla en una sección del capítulo. Las vamos a recorrer con un caso que nos queda cerca.

#cap1-recuadro("El caso: detectar el tizón de la papa")[
  Una cooperativa de productores de papa del altiplano quiere una aplicación para celular que, con una foto de la hoja, diga si la planta tiene *tizón tardío*, una enfermedad causada por un organismo llamado _Phytophthora infestans_ que puede arruinar una cosecha en pocos días. Detectarlo a tiempo permite actuar antes de que se extienda. Los técnicos agrónomos son pocos y no pueden visitar todas las parcelas.
]

=== Fase 1. Definir el problema

Antes de pensar en redes hay que responder preguntas muy concretas: ¿qué queremos predecir exactamente?, ¿quién usará el resultado y para qué?, ¿cómo sabremos si funciona? También hay que preguntarse si de verdad hace falta una red neuronal (sección 10.3).

En nuestro caso, la respuesta podría ser: «dada la foto de una hoja, decir si está sana o tiene tizón». La meta se fija con números: acertar al menos en 9 de cada 10 hojas. Y aparecen condiciones que cambian todo el diseño: en muchas parcelas no hay señal de internet, así que la aplicación debe funcionar sin conexión en un celular sencillo. Muchos proyectos fracasan aquí, resolviendo con gran esfuerzo un problema que nadie tenía o sin una forma clara de medir el éxito.

=== Fase 2. Recolectar los datos

Una red aprende de ejemplos, así que el siguiente paso es conseguirlos. Agrónomos y productores toman miles de fotos de hojas sanas y enfermas. La variedad importa tanto como la cantidad: fotos con sol y con nubes, de distintas variedades de papa, de varias comunidades, tomadas con distintos celulares. Si todas las fotos de hojas enfermas se tomaran en días nublados, la red podría aprender a reconocer las nubes en vez de la enfermedad. Qué datos necesita una red y de dónde salen es el tema de la sección 11.1.

=== Fase 3. Preparar los datos

Los datos crudos casi nunca sirven tal como llegan. Hay fotos borrosas, repetidas o de otra planta. Todas deben llevarse al mismo tamaño y escala. Y cada foto necesita su *etiqueta*: un agrónomo debe marcar cuál está sana y cuál enferma. Si las etiquetas están mal, la red aprende mal, por muy buena que sea. Finalmente, los ejemplos se dividen en tres grupos: uno para entrenar, otro para ajustar decisiones durante el desarrollo (validación) y otro que se guarda para la prueba final. Todo esto se explica en las secciones 11.2 a 11.5.

=== Fase 4. Diseñar la red

Ahora sí se elige la arquitectura: cuántas capas tendrá la red, cuántos nodos en cada una, qué funciones de activación y cómo se conectan. Para fotos se suelen usar redes especializadas en imágenes, llamadas convolucionales (sección 17.1). Como la aplicación debe funcionar en un celular sin internet, se elige un diseño pequeño y liviano, aunque sea un poco menos preciso que uno enorme. Diseñar es siempre negociar entre lo ideal y lo posible. La anatomía de una red se estudia en la sección 12.

=== Fase 5. Entrenar

La red recibe las fotos de entrenamiento una y otra vez. Cada vez que se equivoca, se mide el error y se corrigen los pesos para equivocarse un poco menos. Cada pasada completa por todos los datos se llama *época*. Durante el entrenamiento se vigila que la red no *memorice* las fotos en vez de aprender el patrón: si acierta casi todo con las fotos que ya vio, pero falla con las de validación, algo anda mal. La sección 13 explica este proceso en detalle.

=== Fase 6. Evaluar

Con el entrenamiento terminado, se usa el grupo de prueba, las fotos que la red nunca vio. Supongamos que acierta en 92 de cada 100: supera la meta. Pero una buena evaluación mira más allá del promedio. Al revisar los errores se descubre que la red falla mucho más con fotos tomadas al atardecer. Eso obliga a volver a la fase 2 y conseguir más fotos con esa luz. Evaluar no es poner una nota, es encontrar dónde y por qué falla el modelo (sección 14).

=== Fase 7. Desplegar

Un modelo que solo funciona en la computadora del laboratorio no ayuda a nadie. Desplegar es ponerlo a trabajar en el mundo real: guardarlo, convertirlo a un formato liviano, integrarlo en la aplicación de la cooperativa y probar que responde bien y rápido en los celulares de los productores. Estas tareas son el tema de la sección 15.

=== Fase 8. Monitorear

El trabajo no termina con la entrega. El mundo cambia y el modelo puede quedarse atrás. Un año después aparece una variedad nueva de papa con hojas de otro color y los aciertos bajan. Si nadie vigila, la aplicación seguirá dando respuestas con aparente seguridad, pero cada vez más equivocadas. Monitorear significa medir el desempeño en uso, detectar esos cambios y volver a entrenar cuando haga falta (sección 16).

=== No es una línea, es un ciclo

Aunque las presentamos en orden, las fases no se recorren una sola vez. La evaluación puede mandarte de vuelta a recolectar datos y el monitoreo, a entrenar de nuevo. Por eso conviene imaginar el proyecto como un ciclo.

#align(center)[
  #block(breakable: false, above: 1.2em, below: 1.2em)[
    #set text(size: 9.5pt)
    #set par(first-line-indent: 0em, justify: false)
    #let fase(n, t) = box(width: 2.9cm, stroke: 1.5pt + azul-acento, inset: 6pt, fill: white)[#align(center)[#text(weight: "bold", fill: azul-noche)[#n] \ #t]]
    #grid(
      columns: (auto, auto, auto, auto, auto, auto, auto),
      column-gutter: 4pt, row-gutter: 10pt, align: horizon,
      fase("1", "Definir el problema"), sym.arrow.r, fase("2", "Recolectar datos"), sym.arrow.r, fase("3", "Preparar datos"), sym.arrow.r, fase("4", "Diseñar la red"),
      [], [], [], [], [], [], align(center)[#sym.arrow.b],
      fase("8", "Monitorear"), sym.arrow.l, fase("7", "Desplegar"), sym.arrow.l, fase("6", "Evaluar"), sym.arrow.l, fase("5", "Entrenar"),
    )
    #v(0.4em)
    #text(size: 9pt, fill: azul-trueno)[Del monitoreo (8) y de la evaluación (6) se vuelve a la recolección de datos (2) cuando el modelo empieza a fallar.]
  ]
]

#cap1-tabla(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  table.header([*Fase*], [*Pregunta que responde*], [*Error común*]),
  [1. Definir], [¿Qué problema resolvemos y cómo mediremos el éxito?], [Empezar a programar sin una meta clara.],
  [2. Recolectar], [¿Qué ejemplos tenemos y representan la realidad?], [Usar pocos datos o datos de una sola situación.],
  [3. Preparar], [¿Están limpios, etiquetados y bien divididos?], [Etiquetas equivocadas o mezclar datos de prueba con los de entrenamiento.],
  [4. Diseñar], [¿Qué arquitectura se ajusta al problema y a los recursos?], [Elegir la red más grande sin pensar dónde va a funcionar.],
  [5. Entrenar], [¿La red está aprendiendo el patrón?], [No notar que la red memoriza en vez de aprender.],
  [6. Evaluar], [¿Funciona con datos nuevos? ¿Dónde falla?], [Mirar solo el promedio de aciertos.],
  [7. Desplegar], [¿Funciona en el lugar real, con los usuarios reales?], [Probar solo en el laboratorio.],
  [8. Monitorear], [¿Sigue funcionando con el paso del tiempo?], [Creer que el proyecto terminó con la entrega.],
)

#cap1-recuadro("Para recordar")[
  - Un proyecto de red neuronal tiene ocho fases: definir, recolectar, preparar, diseñar, entrenar, evaluar, desplegar y monitorear.
  - Entrenar es solo una de ellas; el trabajo con los datos suele ocupar la mayor parte del esfuerzo.
  - Las fases forman un ciclo: cuando el mundo cambia, se vuelve a recolectar datos y a entrenar.
]

#cap1-qr(bytes(```svg <svg xmlns="http://www.w3.org/2000/svg" width="450" height="450" class="segno"><path transform="scale(10)" class="qrline" stroke="#0a2540" d="M4 4.5h7m2 0h1m1 0h1m1 0h2m3 0h4m2 0h1m1 0h3m1 0h7m-37 1h1m5 0h1m4 0h1m5 0h1m7 0h1m2 0h1m1 0h1m5 0h1m-37 1h1m1 0h3m1 0h1m1 0h1m1 0h2m4 0h2m2 0h3m1 0h1m1 0h1m3 0h1m1 0h3m1 0h1m-37 1h1m1 0h3m1 0h1m2 0h1m1 0h1m1 0h3m1 0h1m7 0h4m1 0h1m1 0h3m1 0h1m-37 1h1m1 0h3m1 0h1m1 0h1m1 0h2m2 0h1m2 0h4m1 0h2m1 0h3m2 0h1m1 0h3m1 0h1m-37 1h1m5 0h1m1 0h2m3 0h3m2 0h1m2 0h1m2 0h3m1 0h1m1 0h1m5 0h1m-37 1h7m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h7m-27 1h1m2 0h1m1 0h1m1 0h1m2 0h3m3 0h1m-26 1h1m2 0h1m1 0h1m1 0h1m1 0h1m2 0h1m1 0h2m2 0h1m1 0h1m2 0h1m2 0h1m1 0h1m1 0h2m1 0h1m-35 1h1m2 0h2m2 0h1m2 0h1m3 0h2m1 0h1m1 0h1m1 0h1m1 0h1m3 0h3m1 0h3m-31 1h1m1 0h3m2 0h3m5 0h1m1 0h1m2 0h7m1 0h2m1 0h2m-36 1h4m1 0h1m1 0h1m1 0h2m1 0h1m1 0h5m2 0h1m1 0h2m1 0h1m2 0h1m4 0h1m1 0h1m-35 1h1m2 0h4m1 0h1m1 0h1m1 0h1m1 0h2m2 0h3m6 0h3m1 0h3m-33 1h1m1 0h1m3 0h5m1 0h1m1 0h4m2 0h1m2 0h2m1 0h1m2 0h1m1 0h1m-29 1h1m1 0h2m1 0h1m1 0h2m3 0h1m2 0h4m2 0h1m1 0h1m1 0h1m1 0h2m-35 1h3m2 0h1m4 0h2m1 0h1m1 0h2m1 0h2m1 0h4m1 0h1m1 0h4m2 0h3m-36 1h4m1 0h1m3 0h2m3 0h1m2 0h1m5 0h1m5 0h1m2 0h3m-34 1h1m5 0h1m1 0h2m2 0h1m3 0h1m4 0h2m2 0h3m1 0h4m-35 1h5m1 0h2m2 0h4m2 0h3m2 0h8m2 0h2m-33 1h2m1 0h1m3 0h3m4 0h1m1 0h4m1 0h2m6 0h1m1 0h2m1 0h1m-34 1h2m1 0h1m1 0h3m4 0h1m1 0h1m1 0h3m1 0h2m4 0h1m1 0h2m2 0h2m-35 1h1m4 0h1m2 0h2m3 0h1m1 0h1m3 0h1m1 0h1m1 0h1m1 0h3m4 0h3m-34 1h1m4 0h3m2 0h1m1 0h1m3 0h3m3 0h3m1 0h3m-29 1h1m1 0h3m2 0h2m2 0h3m1 0h1m3 0h5m1 0h1m1 0h4m2 0h2m-35 1h4m1 0h1m2 0h1m2 0h2m2 0h1m1 0h2m1 0h2m4 0h1m2 0h2m1 0h3m-36 1h1m1 0h3m4 0h1m1 0h1m6 0h4m1 0h1m1 0h4m3 0h1m-31 1h1m1 0h1m1 0h4m3 0h2m1 0h1m2 0h2m2 0h1m3 0h1m1 0h1m1 0h2m-31 1h4m5 0h1m2 0h3m1 0h1m2 0h3m2 0h1m3 0h5m-35 1h2m1 0h2m1 0h1m1 0h2m1 0h1m1 0h1m1 0h1m1 0h2m1 0h5m2 0h6m1 0h1m-27 1h2m2 0h1m3 0h1m1 0h4m1 0h1m1 0h4m3 0h2m-34 1h7m2 0h1m1 0h1m3 0h1m1 0h4m2 0h1m2 0h1m1 0h1m1 0h1m1 0h3m-35 1h1m5 0h1m3 0h2m1 0h7m2 0h3m3 0h1m3 0h1m1 0h1m-35 1h1m1 0h3m1 0h1m1 0h1m2 0h4m4 0h1m2 0h2m4 0h7m1 0h1m-37 1h1m1 0h3m1 0h1m2 0h1m2 0h1m2 0h2m2 0h2m2 0h1m1 0h3m2 0h2m2 0h2m-36 1h1m1 0h3m1 0h1m7 0h1m1 0h1m1 0h1m1 0h5m1 0h1m1 0h1m1 0h2m1 0h1m1 0h1m-36 1h1m5 0h1m1 0h1m2 0h1m3 0h2m1 0h1m2 0h1m1 0h2m1 0h2m4 0h1m1 0h2m-36 1h7m2 0h1m1 0h5m3 0h4m6 0h1m1 0h2m1 0h3"/></svg>```.text), "alexpanozo27.github.io/redes-neuronales/c2/fases", [Laboratorio 10.4: ordena las ocho fases de la app que detecta el tizón y mira qué pasa en cada una.], disponible: true)

=== Preguntas de repaso de la sección 10

+ ¿Qué parte de la neurona biológica se convirtió en el peso de la neurona artificial? ¿Por qué es la parte más importante para aprender?
+ Menciona dos diferencias entre una neurona del cerebro y una neurona artificial.
+ Un nodo tiene entradas $x_1 = 1$ y $x_2 = 0.5$, pesos $w_1 = 0.4$ y $w_2 = -1$, sesgo $b = 0.2$ y función escalón. ¿Cuál es su salida?
+ ¿Por qué se dice que el nodo es la unidad mínima de una red?
+ Explica con tus palabras la diferencia entre programar reglas y entrenar una red neuronal.
+ ¿En qué fase de un proyecto se decide cómo se medirá el éxito? ¿Por qué no conviene dejarlo para el final?

#cap1-recuadro("Respuestas")[
  + La sinapsis. Su fuerza cambia con la experiencia, y en la red esa fuerza es el peso: aprender consiste en ajustar los pesos.
  + Por ejemplo: la neurona real es una célula viva y la artificial, una fórmula; el cerebro aprende de pocos ejemplos y gasta unos 20 vatios, mientras que una red necesita muchos datos y mucha energía.
  + $z = 0.4 times 1 + (-1) times 0.5 + 0.2 = 0.1$. Como $z >= 0$, la salida es 1.
  + Porque es la pieza más pequeña que hace un cálculo completo (recibir, combinar y decidir). Todo lo demás se construye conectando nodos.
  + En la programación tradicional una persona escribe las reglas; en una red se le dan datos con sus respuestas y el entrenamiento encuentra las reglas, que quedan guardadas en los pesos.
  + En la fase 1. Si no se sabe desde el inicio qué significa funcionar bien, no hay forma de decidir qué datos reunir, qué red diseñar ni cuándo el trabajo está terminado.
]

// -------------------------------------------------------------------
// Aquí van las secciones 11 a 16 y la 17.1 de los demás autores.
// La sección 17.2 va después del encabezado "= 17. Más allá del modelo
// básico" y de la 17.1 (Katerin).
// -------------------------------------------------------------------

== 17.2 Redes neuronales aplicadas a la Ingeniería de Sistemas

=== El ingeniero de sistemas frente a las redes

La Ingeniería de Sistemas tiene una relación doble con las redes neuronales. Por un lado, es la carrera que las construye y las pone en marcha: alguien tiene que preparar los servidores, organizar los datos, integrar el modelo en una aplicación y mantenerlo funcionando. Por otro lado, los propios sistemas informáticos (redes de computadoras, bases de datos, servidores, programas) producen enormes cantidades de datos, y las redes neuronales se han vuelto una herramienta para cuidarlos, protegerlos y mejorarlos.

En esta sección vamos a recorrer cinco áreas donde eso ya ocurre y, al final, un caso guiado que muestra cómo trabaja un equipo de sistemas con una red neuronal.

=== Seguridad informática

Los atacantes cambian de táctica todo el tiempo, y por eso las reglas fijas envejecen rápido. Una regla que bloquea una dirección sospechosa deja de servir cuando el atacante usa otra. Las redes neuronales permiten un enfoque distinto: en lugar de describir cada ataque, aprenden cómo es el comportamiento normal y avisan cuando algo se aparta de él. A esto se le llama *detección de anomalías* (Chandola et al., 2009).

Así funcionan muchos sistemas de detección de intrusos, que vigilan el tráfico de una red y alertan ante patrones extraños, como miles de intentos de inicio de sesión en pocos minutos. También se usan redes para reconocer correos de _phishing_, esos mensajes que imitan a un banco para robar contraseñas, y para clasificar archivos como posibles programas maliciosos. En todos los casos la red ayuda a filtrar; la decisión de bloquear o investigar sigue en manos de una persona.

=== Operación de servidores y centros de datos

Un servidor genera miles de líneas de registro (los llamados _logs_) y cientos de métricas por minuto: uso de memoria, tiempo de respuesta, cantidad de peticiones. Nadie puede leerlo todo. Las redes neuronales pueden aprender el patrón normal de esos registros y señalar los momentos raros. Un trabajo conocido, DeepLog, entrenó una red con los registros de sistemas en buen estado y logró detectar fallas y ataques como desviaciones de ese patrón (Du et al., 2017).

Otra aplicación es predecir la carga: cuántos usuarios entrarán a un sistema a cierta hora, para encender más servidores antes de que se saturen. Y en los grandes centros de datos, donde enfriar las máquinas cuesta mucha energía, DeepMind informó que un sistema basado en redes neuronales redujo en un 40 % la energía usada para enfriar los centros de datos de Google (Evans y Gao, 2016).

=== Desarrollo de software

Los asistentes de programación, que sugieren líneas de código mientras se escribe, se basan en grandes redes neuronales entrenadas con código público (Chen et al., 2021). En un experimento controlado, los programadores que usaron uno de estos asistentes terminaron una tarea alrededor de un 56 % más rápido que quienes no lo usaron (Peng et al., 2023).

Hay que leer ese dato con cuidado. El asistente puede sugerir código con errores o con fallas de seguridad, y lo hace con la misma seguridad con que sugiere código correcto: es el mismo problema de las alucinaciones que vimos en la sección 2.3. Por eso el ingeniero sigue siendo responsable de revisar, probar y entender cada línea que entra a un sistema. Usado así, el asistente es una herramienta que acelera; usado sin criterio, es una fuente de errores difíciles de encontrar.

=== Bases de datos y sistemas de información

Incluso las bases de datos, una de las áreas más clásicas de la carrera, están incorporando ideas de las redes. Un trabajo influyente propuso reemplazar algunas estructuras de índice tradicionales por modelos que aprenden dónde está guardado cada dato, con resultados más rápidos y que ocupan menos memoria en ciertos casos (Kraska et al., 2018).

En los sistemas de información de empresas e instituciones, las redes aparecen en tareas más visibles: asistentes que responden consultas de clientes a cualquier hora, sistemas que clasifican los pedidos de soporte técnico y los envían al equipo correcto, o motores que recomiendan productos según lo que cada persona compró antes.

=== El rol del ingeniero de sistemas

Detrás de cada uno de estos ejemplos hay mucho trabajo de ingeniería que no aparece en las noticias. Alguien tiene que diseñar cómo llegan los datos al modelo, dónde se ejecuta, cómo se actualiza sin interrumpir el servicio, cómo se protege la información personal y cómo se detecta que el modelo empezó a fallar. A ese conjunto de prácticas se lo conoce como *MLOps*, por la unión de _machine learning_ (aprendizaje automático) y _operations_ (operaciones). Es, en buena medida, el recorrido de las fases 7 y 8 de la sección 10.4, y es un campo de trabajo natural para quien estudia Ingeniería de Sistemas.

=== Caso guiado: una alarma para el sistema de inscripciones

Imagina que trabajas en el área de sistemas de una universidad. Durante las semanas de inscripción, el servidor recibe picos enormes de tráfico, y el año pasado una falla pasó horas sin que nadie la notara. Se decide usar una red neuronal para vigilarlo.

*Paso 1. Aprender lo normal.* Se entrena una red con los registros de varias semanas de funcionamiento normal. La red aprende a predecir cuántas peticiones por minuto deberían llegar a cada hora: pocas de madrugada, muchas a media mañana, un segundo pico por la tarde.

*Paso 2. Comparar.* Cada minuto, el sistema compara lo que la red esperaba con lo que realmente llegó. Supongamos que a las 10:00 la red espera 300 peticiones por minuto y que lo normal es que el valor real varíe unas 36 peticiones hacia arriba o hacia abajo.

*Paso 3. Decidir cuándo avisar.* El equipo fija una regla: si la diferencia supera tres veces esa variación normal ($3 times 36 = 108$ peticiones), se dispara una alerta. Si a las 10:00 llegan 350 peticiones, la diferencia es 50 y no pasa nada. Si llegan 900, la diferencia es 600 y suena la alarma.

*Paso 4. Revisar.* Una alerta no es un diagnóstico. Si a las 18:00 se publican las notas y todos los estudiantes entran a la vez, el tráfico se dispara sin que haya un ataque. La red solo sabe que algo es raro; la persona de turno decide si es un problema.

El número que multiplica a la variación normal, el 3 de nuestro ejemplo, es la *sensibilidad* de la alarma. Si se baja a 1, la alarma salta por cualquier subida pequeña y el equipo termina ignorándola. Si se sube a 6, deja pasar ataques discretos. No existe un valor perfecto: elegirlo depende de cuánto cuesta una falsa alarma y cuánto cuesta un problema no detectado. Esa decisión es de ingeniería, no de la red.

#cap1-recuadro("Ejercicio resuelto: ¿suena la alarma?")[
  A las 03:00 la red espera 40 peticiones por minuto, con una variación normal de 15. La sensibilidad es 3. ¿Qué pasa si llegan (a) 70 peticiones y (b) 460 peticiones?

  _Solución:_ el límite es $3 times 15 = 45$. (a) La diferencia es $70 - 40 = 30$, menor que 45: no hay alerta. (b) La diferencia es $460 - 40 = 420$, mucho mayor que 45: suena la alarma. Un salto así de madrugada es típico de un ataque de denegación de servicio, en el que miles de peticiones falsas intentan saturar el servidor.
]

#cap1-recuadro("Para pensar")[
  Las redes neuronales que vigilan sistemas también procesan datos de personas: quién se conecta, desde dónde y a qué hora. Usarlas bien exige proteger esa información y no usarla para fines distintos de la seguridad. La ética y la privacidad en sistemas en producción se tratan en las secciones 16.5 y 16.6.
]

#cap1-recuadro("Para recordar")[
  - En Ingeniería de Sistemas, las redes neuronales se usan en seguridad, operación de servidores, desarrollo de software, bases de datos y sistemas de información.
  - Una técnica muy útil es la detección de anomalías: la red aprende lo normal y avisa cuando algo se aparta de ello.
  - La red avisa y sugiere; el ingeniero revisa, decide y responde por el sistema.
]

#cap1-qr(bytes(```svg <svg xmlns="http://www.w3.org/2000/svg" width="490" height="490" class="segno"><path transform="scale(10)" class="qrline" stroke="#0a2540" d="M4 4.5h7m1 0h1m2 0h1m1 0h2m1 0h1m3 0h2m1 0h1m4 0h2m1 0h2m1 0h7m-41 1h1m5 0h1m2 0h1m1 0h2m1 0h1m1 0h1m4 0h2m1 0h1m1 0h3m3 0h1m1 0h1m5 0h1m-41 1h1m1 0h3m1 0h1m2 0h3m1 0h5m1 0h6m1 0h1m1 0h1m3 0h1m1 0h1m1 0h3m1 0h1m-41 1h1m1 0h3m1 0h1m3 0h2m2 0h1m2 0h1m1 0h3m2 0h3m2 0h1m4 0h1m1 0h3m1 0h1m-41 1h1m1 0h3m1 0h1m1 0h1m1 0h1m3 0h1m1 0h1m2 0h1m1 0h2m5 0h1m2 0h1m2 0h1m1 0h3m1 0h1m-41 1h1m5 0h1m1 0h2m4 0h1m12 0h1m2 0h1m3 0h1m5 0h1m-41 1h7m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h1m1 0h7m-32 1h7m4 0h1m1 0h1m3 0h1m4 0h1m-31 1h7m3 0h1m1 0h1m1 0h1m2 0h1m2 0h2m1 0h4m1 0h1m5 0h2m3 0h1m-39 1h1m2 0h1m1 0h2m2 0h4m1 0h1m1 0h1m1 0h2m1 0h1m4 0h9m1 0h3m-40 1h1m1 0h2m1 0h2m3 0h1m1 0h2m1 0h1m2 0h2m5 0h2m1 0h1m2 0h2m1 0h1m-36 1h1m1 0h1m1 0h1m5 0h1m4 0h1m2 0h2m1 0h1m1 0h2m1 0h2m2 0h3m2 0h1m1 0h1m-35 1h7m3 0h2m2 0h2m1 0h1m2 0h5m1 0h1m1 0h1m1 0h1m1 0h1m1 0h4m-40 1h1m2 0h2m4 0h3m1 0h2m1 0h6m1 0h2m2 0h1m1 0h2m1 0h5m1 0h2m-41 1h3m1 0h1m1 0h1m1 0h1m1 0h3m2 0h1m2 0h1m8 0h1m1 0h2m1 0h2m1 0h4m-37 1h4m5 0h1m2 0h1m1 0h8m2 0h3m3 0h1m1 0h1m4 0h2m-41 1h4m1 0h7m1 0h3m1 0h1m2 0h1m1 0h6m1 0h2m2 0h1m1 0h1m2 0h1m1 0h1m-41 1h1m2 0h1m3 0h1m1 0h2m2 0h1m1 0h3m2 0h4m1 0h1m4 0h3m1 0h4m2 0h1m-40 1h10m6 0h4m1 0h1m3 0h2m1 0h2m5 0h2m1 0h1m-40 1h1m1 0h1m1 0h2m1 0h3m1 0h2m1 0h2m5 0h1m4 0h1m5 0h2m2 0h2m1 0h2m-41 1h1m2 0h1m2 0h2m2 0h1m1 0h2m2 0h1m1 0h2m1 0h2m1 0h6m1 0h1m5 0h3m-40 1h2m1 0h1m7 0h1m1 0h1m1 0h1m3 0h2m1 0h4m2 0h10m1 0h2m-40 1h1m3 0h5m2 0h1m1 0h1m1 0h4m2 0h1m2 0h4m3 0h1m1 0h4m-37 1h5m1 0h5m3 0h4m1 0h2m1 0h2m3 0h1m1 0h1m1 0h3m2 0h1m1 0h2m-38 1h1m2 0h1m1 0h1m1 0h1m2 0h1m1 0h1m1 0h1m6 0h3m1 0h2m7 0h4m-38 1h2m3 0h2m1 0h2m1 0h4m2 0h1m1 0h2m4 0h4m1 0h5m1 0h2m-41 1h3m1 0h4m2 0h1m1 0h1m1 0h2m1 0h2m2 0h2m1 0h1m1 0h2m2 0h1m1 0h1m1 0h1m-34 1h1m1 0h2m3 0h1m1 0h1m1 0h2m3 0h1m2 0h5m2 0h1m3 0h2m3 0h2m1 0h2m-38 1h5m1 0h1m4 0h1m2 0h1m1 0h1m2 0h5m1 0h2m1 0h1m5 0h2m1 0h1m-41 1h1m3 0h2m1 0h1m3 0h2m2 0h1m2 0h3m1 0h4m2 0h13m-41 1h1m3 0h1m1 0h4m1 0h2m1 0h2m3 0h3m3 0h5m3 0h3m2 0h1m-39 1h1m2 0h1m1 0h1m1 0h1m1 0h1m1 0h1m2 0h1m1 0h1m2 0h1m3 0h2m7 0h6m-38 1h1m1 0h1m2 0h2m13 0h1m3 0h6m2 0h5m1 0h1m1 0h1m-33 1h4m2 0h1m8 0h1m5 0h2m1 0h1m3 0h2m2 0h1m-41 1h7m1 0h1m3 0h1m1 0h1m2 0h4m1 0h1m4 0h2m1 0h3m1 0h1m1 0h2m1 0h1m-40 1h1m5 0h1m1 0h4m1 0h1m2 0h2m1 0h2m1 0h2m2 0h1m4 0h2m3 0h2m2 0h1m-41 1h1m1 0h3m1 0h1m1 0h1m2 0h1m2 0h2m2 0h2m2 0h1m2 0h3m1 0h1m2 0h7m1 0h1m-41 1h1m1 0h3m1 0h1m1 0h2m1 0h2m1 0h1m4 0h1m1 0h3m1 0h2m4 0h1m1 0h1m1 0h1m3 0h1m-40 1h1m1 0h3m1 0h1m1 0h1m1 0h1m1 0h1m2 0h1m4 0h1m4 0h4m4 0h4m1 0h1m-39 1h1m5 0h1m1 0h1m4 0h4m1 0h1m2 0h1m4 0h1m1 0h1m2 0h4m1 0h2m1 0h1m-40 1h7m3 0h1m3 0h1m2 0h1m1 0h2m4 0h2m1 0h2m1 0h1m1 0h1m1 0h2m1 0h1"/></svg>```.text), "alexpanozo27.github.io/redes-neuronales/c2/ingenieria-de-sistemas", [Laboratorio 17.2: vigila el servidor de inscripciones con una red neuronal y ajusta la sensibilidad de la alarma.], disponible: true)

=== Glosario de las secciones 10 y 17.2

#block(inset: (left: 8pt))[
  #set par(first-line-indent: 0em)
  *Algoritmo:* secuencia ordenada de pasos para resolver un problema. \
  *Anomalía:* comportamiento que se aparta mucho de lo normal; puede ser una falla, un ataque o algo legítimo pero raro. \
  *Axón:* prolongación de la neurona que lleva el impulso hacia otras neuronas. \
  *Dendritas:* ramificaciones de la neurona que reciben señales de otras neuronas. \
  *Entrada:* número que recibe un nodo. \
  *Época:* una pasada completa de la red por todos los datos de entrenamiento. \
  *Función de activación:* regla que transforma la suma ponderada en la salida del nodo. \
  *MLOps:* prácticas para desplegar, mantener y vigilar modelos de aprendizaje automático en sistemas reales. \
  *Nodo:* unidad mínima de una red neuronal; recibe entradas, las combina con sus pesos y produce una salida. \
  *Peso:* número que indica cuánto influye una entrada en la decisión de un nodo; es lo que se ajusta al aprender. \
  *Plasticidad sináptica:* capacidad de las sinapsis de fortalecerse o debilitarse con la experiencia. \
  *Sesgo:* número que se suma en un nodo y representa su inclinación de base. \
  *Sinapsis:* punto de contacto donde una neurona transmite su señal a otra. \
  *Suma ponderada:* suma de cada entrada multiplicada por su peso, más el sesgo.
]

=== Referencias de las secciones 10 y 17.2

#text(size: 9.5pt)[
#set par(first-line-indent: 0em, hanging-indent: 1.2em)
Azevedo, F. A. C., Carvalho, L. R. B., Grinberg, L. T., Farfel, J. M., Ferretti, R. E. L., Leite, R. E. P., Jacob Filho, W., Lent, R. y Herculano-Houzel, S. (2009). Equal numbers of neuronal and nonneuronal cells make the human brain an isometrically scaled-up primate brain. _Journal of Comparative Neurology_, 513(5), 532–541.

Chandola, V., Banerjee, A. y Kumar, V. (2009). Anomaly detection: A survey. _ACM Computing Surveys_, 41(3), 1–58.

Chapman, P., Clinton, J., Kerber, R., Khabaza, T., Reinartz, T., Shearer, C. y Wirth, R. (2000). _CRISP-DM 1.0: Step-by-step data mining guide_. SPSS.

Chen, M. et al. (2021). Evaluating large language models trained on code. _arXiv:2107.03374_.

Chollet, F. (2021). _Deep Learning with Python_ (2.ª ed.). Manning.

Cybenko, G. (1989). Approximation by superpositions of a sigmoidal function. _Mathematics of Control, Signals and Systems_, 2(4), 303–314.

Dijkstra, E. W. (1959). A note on two problems in connexion with graphs. _Numerische Mathematik_, 1, 269–271.

Du, M., Li, F., Zheng, G. y Srikumar, V. (2017). DeepLog: Anomaly detection and diagnosis from system logs through deep learning. En _Proceedings of the 2017 ACM SIGSAC Conference on Computer and Communications Security_ (pp. 1285–1298).

Evans, R. y Gao, J. (2016). _DeepMind AI reduces Google data centre cooling bill by 40%_. DeepMind.

Goodfellow, I., Bengio, Y. y Courville, A. (2016). _Deep Learning_. MIT Press.

Hebb, D. O. (1949). _The Organization of Behavior: A Neuropsychological Theory_. Wiley.

Hornik, K., Stinchcombe, M. y White, H. (1989). Multilayer feedforward networks are universal approximators. _Neural Networks_, 2(5), 359–366.

Kandel, E. R., Schwartz, J. H., Jessell, T. M., Siegelbaum, S. A. y Hudspeth, A. J. (2013). _Principles of Neural Science_ (5.ª ed.). McGraw-Hill.

Kraska, T., Beutel, A., Chi, E. H., Dean, J. y Polyzotis, N. (2018). The case for learned index structures. En _Proceedings of the 2018 International Conference on Management of Data_ (pp. 489–504).

LeCun, Y., Bengio, Y. y Hinton, G. (2015). Deep learning. _Nature_, 521, 436–444.

McCulloch, W. S. y Pitts, W. (1943). A logical calculus of the ideas immanent in nervous activity. _Bulletin of Mathematical Biophysics_, 5, 115–133.

Mitchell, T. M. (1997). _Machine Learning_. McGraw-Hill.

Peng, S., Kalliamvakou, E., Cihon, P. y Demirer, M. (2023). The impact of AI on developer productivity: Evidence from GitHub Copilot. _arXiv:2302.06590_.

Raichle, M. E. y Gusnard, D. A. (2002). Appraising the brain's energy budget. _Proceedings of the National Academy of Sciences_, 99(16), 10237–10239.

Rosenblatt, F. (1958). The perceptron: A probabilistic model for information storage and organization in the brain. _Psychological Review_, 65(6), 386–408.

Sculley, D., Holt, G., Golovin, D., Davydov, E., Phillips, T., Ebner, D., Chaudhary, V., Young, M., Crespo, J.-F. y Dennison, D. (2015). Hidden technical debt in machine learning systems. En _Advances in Neural Information Processing Systems 28_ (pp. 2503–2511).
]
