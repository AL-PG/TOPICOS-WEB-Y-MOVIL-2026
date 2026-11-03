           ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
             EXAMEN — MICROSERVICIOS, GATEWAY Y EL MONOLITO
                                CON API
              Tópicos Selectos de Tecnologías Web y Móvil

                            Eduardo Alcaraz
           ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


Nombre: Aldo Noé Pacheco Gaona           Calificación :_________


## Indicaciones
════════════

  Este examen *no* se aprueba de memoria. Casi todas las preguntas
  tienen una respuesta que «suena bien» y está mal, o dos opciones
  defendibles donde se califica el argumento.

  Reglas:

  • Expliquen el *porqué*. Una conclusión sin razonamiento vale la mitad
    (o menos).
  • Cuando digan «depende», digan *de qué*.
  • No hace falta código que compile; sí hace falta que el diseño cierre
    (quién llama a quién, qué pasa si algo falla, qué ve el cliente).
  • Pueden dibujar. Un dibujo contradictorio con el texto resta.

  Puntaje: *100 puntos* (10 × 10).


## 1 — La frase del compañero (10 puntos)
══════════════════════════════════════

  En el pizarrón quedó:

        La API separa clientes del servidor; los microservicios
        separan servidores entre sí.

  Un compañero dice: «Entonces, si mi monolito Django expone una API y
  además lo meto en Docker, ya cumplí las dos mitades de la frase.»

  a) Desarmen su argumento. ¿Qué parte de la frase cree cumplir con la
  API? ¿Qué parte cree cumplir con Docker? ¿En qué se equivoca en cada
  una?

  R:
  API: considera que exponer una API en Django separa al cliente del servidor. Esto permite que diferentes clientes se comuniquen con el backend. Pero tener una API no significa que el backend esté dividido en microservicios.

  Docker: considera que introducir Django en un contenedor significa separar los servidores. Esto esta mal porque Docker solamente empaqueta y ejecuta la aplicación en un entorno aislado. Un contenedor no equivale a un microservicio.

  b) Den un contraejemplo mínimo: mismo código Django, *con* API y *con*
  Docker, que *sigamos* pudiendo llamar monolito. ¿Qué tendría que
  añadir (o partir) para que deje de serlo?


  c) ¿La frase del pizarrón habla de *tecnologías* (Docker, REST) o de
  *límites de proceso / despliegue*? Defiendan su lectura con lo que
  vieron en clase.

  R: La frase habla de limites de proceso y despligue. Cuando hablamos de docker se habla de una forma de despligue en donde nuestro codigo se pueda empaquetar y ejecutar completamente aislado de todo, esto se usa tanto en monolitos como en microservicios. Ahora con REST es mas una forma en como se deben de hacer las APIs es como un diseño o unas recomendaciones de como crear tus APIs 


## 2 — Tres rutas, una trampa (10 puntos)
══════════════════════════════════════

  El equipo muestra este `urls.py' de un solo proyecto Django:

  ┌────
  │ path("usuarios/", ...),
  │ path("pedidos/", ...),
  │ path("recomendar/", ...),
  └────

  y este `docker-compose.yml':

  ┌────
  │ services:
  │   api:
  │     build: .
  │     ports: ["8000:8000"]
  │     deploy:
  │       replicas: 3
  └────

  Afirman: «Tres rutas + tres réplicas = microservicios con alta
  disponibilidad.»

  a) Separen las dos ideas que mezclaron (rutas vs réplicas). ¿Qué
  problema resuelve cada una y cuál *no* resuelve?

  R: Tanto las rutas como las replicas son dos ideas distintas. Las replicas nos resuelven principalmente problemas de escalamiento ya que cada replica seria una instancia de nuestra aplicacion mientras que las rutas al final son el medio por el cual yo me comunico con mi servidor y pido informacion. 

  b) Si una de las tres réplicas se cae a mitad de un `POST /pedidos',
  ¿el sistema dejó de ser monolito? ¿Por qué sí o por qué no?

  R: No, porque el tipo de arquitectura no depende de cuántas instancias estén ejecutándose, sino de cómo están organizadas las funcionalidades y los despliegues del sistema.

  c) Rediseñen *solo con palabras* el `compose' para que sí ilustre
  microservicios (nombres de servicios y responsabilidades; no hace
  falta YAML perfecto). ¿Cuántas *imágenes distintas* mínimo y por qué
  esa cantidad?

  R: Pues se podria dividir la aplicacion en tres diferentes imagenes:
  - Usuarios: Aqui se gesstionarian los usuarios 
  - Pedidos: Aqui se crean y administran los pedidos
  - Recomendar: Aqui se ejucta el modelo de IA


## 3 — El gateway que «hace de más» (10 puntos)
════════════════════════════════════════════

  Les proponen este diseño «para no complicar»:

        Un solo contenedor nginx+Python que: valida el JWT, elige
        el medio con el `.joblib', guarda el pedido en SQLite,
        manda el correo y devuelve el HTML.

  Lo llaman «API Gateway».

  a) ¿Es un gateway? Si no, ¿qué es? Usen la analogía del recepcionista
  (o otra) y digan qué oficios mezclaron.

  R: No es un gateway aunque hace el trabajo de una. Es una API que mezcla funcionalidades de diferentes componentes. Tomando la analogia es como si la recepcionista ademas de recibir y verificar la identidad de los clientes tambien registrara las ventas, enviara los correos y entregue ella misma los documentos

  b) Mencionen *tres* consecuencias malas de ese diseño cuando el modelo
  pesado se reentrena cada semana y el correo empieza a fallar.

  R: 
  - Pueede crear problemas de rendimiento. Como los entrenamientos de la IA son aveces bastantes pesados en general, cada vez que se entrene va a relentizar todo el sistem. Por eso se tiende a separar especialmente la logica de la IA en otros modulos

  - Si en el caso de que el correo falle puede llegar a retrasar el sistema o que ella errores en el pedido como todo esta junto y a la hora de enviar el correo este tarda en enviarse y como varias partes del sistema estan juntas este retraso se comparte

  - Si el modelo de IA se reentrena cada semana, necesitamos actualizar el archivo .joblib y posiblemente sus dependencias. Al estar todo en un mismo contenedor, debemos volver a desplegar el sistema completo, aunque solamente haya cambiado el modelo.

  c) Partan ese contenedor en piezas. Para cada pieza digan: ¿queda en
  el borde (gateway) o detrás? No inventen diez servicios: el mínimo que
  separe borde, logística e (si hace falta) aviso.

  - Gateway: Quedaria en el borde y se encargaria de las validaciones de identidad y el enrutamiento de solicitudes
  - Logistica: Este quedaria por detras y seria principalmente el modelo y el registro en la BD de los pedidos
  - Avisos/Notificaciones: Igualmente quedaria detras y seria prinicipalmente el de los correos 


## 4 — `localhost', la trampa favorita (10 puntos)
═══════════════════════════════════════════════

  Pedidos corre en un contenedor. Recomendar en otro, misma Compose.
  Alguien «arregla» la conexión así:

  ┌────
  │ RECOMENDAR_URL=http://127.0.0.1:8002
  └────

  En su laptop, *sin* Docker, ese `curl' a `127.0.0.1:8002' sí
  funcionaba.

  a) Expliquen por qué en Compose ese arreglo suele fallar *aunque*
  Recomendar esté sano. ¿A qué proceso apunta `127.0.0.1' desde dentro
  de Pedidos?

  R: Porque cada contenedor esta completamente aislado, por eso al poner 127.0.0.1 esto esta apuntando al propio contenedor no a otros contenedores ni a la misma computadora

  b) ¿Por qué `http://recomendar:8002' sí tiene chance de funcionar?
  ¿Quién «inventa» el nombre `recomendar'?

  R: Porque docker tiene un funcion para que se puedan registrar los nombres de los servicios en el DNS del propio doker. El nombre lo definimos nosotros o un compañero y simplemente ponemos hacia que puertos apunta ese servicio

  c) Ahora Recomendar se muda a la laptop de otro alumno
  (`192.168.0.57'). Escriban la URL que pondrían *y* dos cosas que
  tienen que ser verdad en la WiFi para que no sea teatro (puertos,
  firewall, etc.). Si solo cambian la URL y nada más, ¿qué puede seguir
  fallando?


## 5 — Fallo parcial con números (10 puntos)
═════════════════════════════════════════

  Escenario medido en laboratorio (inventado pero coherente):

  • 1000 `POST /pedidos' por hora en promedio.
  • Recomendar tarda 200 ms cuando está bien.
  • El 5 % del tiempo Recomendar no responde (timeout 3 s).
  • Pedidos, si hay timeout, usa plan B (moto) y responde 200 en 50 ms.
  • El gateway añade 5 ms.

  a) En la hora «normal» (Recomendar bien), ¿el cliente espera ~200 ms o
  ~3 s? ¿Quién pone el tiempo dominante?

  R: Tardaria unos 200ms un poco mas si añades lo del gateway, entonces pongamos que serian unos 205ms por cliente. Al final es tiempo dominante seria el caso en elque el recomendar esta funcionando correctamente

  b) En el 5 % malo, con plan B: ¿el cliente ve error o pedido creado?
  ¿Qué «mentira útil» están aceptando (medio quizá no óptimo)?

  R: Responderia con un 200 y crea el pedido ya que con el plan B recomendaria con una moto, aunque esto pudiera ser falso

  c) Un compañero dice: «Mejor que Pedidos *reintente* 10 veces hasta
  que Recomendar vuelva; así nunca usamos plan B.» ¿Qué le pasa a la
  cola de peticiones y al gateway si Recomendar está caído 10 minutos?
  ¿Plan B siempre es peor que reintentar? Argumenten.

  R: Empeoraria por mucho tanto el redimiento como la disponibilidad ya que podria empezar a acumular peticiones y reintentarlas e incluso podira sobrecargar el server.


## 6 — Apagan el «edificio equivocado» (10 puntos)
═══════════════════════════════════════════════

  Tres contenedores: gateway, pedidos, recomendar. Hacen tres
  experimentos *por separado*:

  1. `docker compose stop gateway'
  2. `docker compose stop pedidos'
  3. `docker compose stop recomendar'

  Para *cada* experimento digan qué ve el navegador en `http://IP:8080/'
  (página / crear pedido) y qué sigue vivo por dentro. No basta «no
  jala»: digan *qué* no jala y qué sí podría seguir respondiendo si
  alguien hablara por dentro de la red.

  Luego: ¿en cuál de los tres el sistema «parece» más muerto hacia
  afuera aunque más piezas sigan arriba? ¿Qué les enseña eso del borde?


## 7 — WiFi del salón, conflicto de roles (10 puntos)
══════════════════════════════════════════════════

  Cuatro alumnos:

  • Ana: gateway + HTML
  • Beto: pedidos
  • Carla: recomendar
  • Diana: «yo también levanté un gateway en mi laptop por si Ana falla»

  Todos en la misma WiFi. El cliente (otro equipo) configura a veces la
  IP de Ana y a veces la de Diana.

  a) ¿Qué problema de *diseño* introdujo Diana aunque «todo responda
  200»? (Piensen en una sola puerta vs dos puertas.)

  b) Beto configuró `RECOMENDAR_URL=http://localhost:8002' porque en su
  máquina desarrolló Pedidos y Recomendar juntos. En el salón Recomendar
  está en la laptop de Carla. ¿Qué falla y cómo lo corrigen *sin* juntar
  otra vez los dos servicios en la laptop de Beto?

  c) La WiFi del campus aísla clientes («AP isolation»). `ping' entre
  alumnos falla. ¿Pueden hacer la práctica tal cual? Si no, propongan
  *un* plan B de laboratorio que preserve la lección «procesos
  separados» (aunque no sea WiFi del salón).


## 8 — El front que conoce demasiado (10 puntos)
═════════════════════════════════════════════

  El HTML hace esto al enviar el formulario:

  ┌────
  │ await fetch("http://192.168.1.20:8002/sugerir", { ... }); // Recomendar
  │ await fetch("http://192.168.1.30:8001/pedidos", { ... }); // Pedidos
  └────

  El autor dice: «Más rápido: me salto el gateway.»

  a) Listen *tres* problemas (seguridad, cambio de IP, orden de
  llamadas, consistencia del folio, CORS, etc.).

  b) Rediseñen la secuencia correcta con gateway: *una* llamada desde el
  navegador. ¿Quién habla con Recomendar y por qué no el navegador?

  c) El selector de modelo (`arbol=|=bosque=|=red') va en el JSON. Si el
  front llama directo a Recomendar *y* a Pedidos, ¿quién debería crear
  el folio para no duplicar lógica? ¿Qué invariante rompen si los dos
  «crean» algo?


## 9 — El LLM vendedor (10 puntos)
═══════════════════════════════

  Producto: tienda + envíos.

  • Modelo `.joblib': medio de transporte.
  • LLM: texto para convencer al cliente en la ficha del producto.

  Un arquitecto propone *un solo* microservicio `cerebro' que: recibe el
  carrito, elige el medio con el árbol *y* genera el pitch de ventas con
  el LLM, todo en la misma petición `/inteligente'.

  a) Critiquen el nombre y el corte. ¿Qué dos oficios distintos
  mezclaron? ¿Qué falla cuando el LLM tarda 8 s y el despacho necesita
  responder en < 500 ms?

  b) Propongan dos endpoints (o dos servicios) y digan cuál usa el
  *front de tienda* y cuál el *flujo de pedido/envío*.

  c) El LLM vive en un server con GPU en otra red. El front de tienda
  ¿apunta a la GPU o al gateway? Si mañana cambian de proveedor LLM
  (otro host), ¿qué archivo/config quieren tocar *una sola vez*?


## 10 — El inversionista y la semana imposible (10 puntos)
═══════════════════════════════════════════════════════

  Hoy:

  • Panel interno: monolito Django (funciona, poco tráfico).
  • App clientes: gateway + pedidos + recomendar.
  • Idea: LLM de ventas (aún no).
  • Equipo: 5 personas.
  • Inversionista: «Todo a microservicios en 7 días, incluido el panel,
    o no hay dinero.»

  a) Escriban la respuesta al inversionista (máx. 8 líneas) con postura
  *y* riesgo concreto si obedecen a ciegas.

  b) Ordenen *estas cuatro* iniciativas de más a menos urgente para
  *esta* semana y justifiquen el orden (no el catálogo soñado):

  1. Partir el panel Django en 6 microservicios.
  2. Sacar el reentrenamiento del `.joblib' a un pipeline que no tumbe
     Pedidos.
  3. Meter auth + rate limit en el gateway público.
  4. Subir el LLM de ventas a producción sin timeouts ni plan B.

  c) Inventen *una* métrica que les diga «ya toca partir X del monolito»
  (no «porque está de moda»). Tiene que ser observable (tiempo, errores,
  despliegues, equipo…).

  d) Cierren con una frase propia (no copien el apunte) que capture:
  ¿microservicios son el objetivo o la herramienta?
