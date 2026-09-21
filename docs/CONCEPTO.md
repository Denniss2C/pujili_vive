# Pujilí Vive — Concepto de producto

> **Qué es este documento.** El *qué* y el *porqué* del producto. No hay código.
> Está escrito para alguien que nunca vio las conversaciones: cada pantalla se
> describe por escrito y con un esquema ASCII, sin depender de ninguna imagen.
>
> **Va acompañado de `docs/MOCKS.html`**, que contiene las siete pantallas
> dibujadas y corregidas. Ese archivo se abre en el navegador para verlas y
> también se lee como texto. Este documento manda en el *qué* y el *porqué*;
> `MOCKS.html` manda en la composición visual concreta. Donde uno de los dos
> diga algo más específico que el otro, gana el más específico; si se
> contradicen, es un bug del documento y hay que preguntar.
>
> **Convención de marcas.** Cada afirmación va marcada:
> - `[DECIDIDO]` — acordado explícitamente con el product owner (Dennis) en las
>   sesiones previas. No re-abrir sin hablarlo.
> - `[PROPUESTA]` — salió del diseño o de una sugerencia no ratificada. Se
>   puede discutir y cambiar.
>
> Lo que no está decidido **no se rellena**: va al final, en "Preguntas abiertas".
>
> **Convención de nombres.** Features, entidades y campos en inglés (convención
> del repo). Los textos de producto visibles al usuario, en español (y su
> traducción al inglés, ver bilingüismo).

---

## 1. La idea en un párrafo

`[DECIDIDO]` Pujilí Vive es una app móvil informativa sobre el cantón Pujilí
(provincia de Cotopaxi, Ecuador) que reúne en un solo lugar qué ver, cuándo ir y
a quién comprarle. Hoy la información del cantón está dispersa entre publicaciones
de redes sociales, notas de prensa y el boca a boca; en particular, las fiestas
—el Corpus Christi y el Danzante de Pujilí son el motivo real por el que la gente
viaja al cantón— no tienen ningún calendario consultable y confiable. La app la
usa quien ya decidió visitar Pujilí o está a punto de decidirlo, y responde tres
preguntas: qué atractivos hay y cómo llegar, cuándo es la próxima fiesta, y dónde
están los talleres artesanales y la comida típica. `[DECIDIDO]` En su primera
versión es contenido estático empaquetado en la app, sin backend, sin cuentas de
usuario y sin transacciones.

---

## 2. Usuarios objetivo

`[DECIDIDO]` El usuario primario es el visitante. Los demás perfiles existen,
pero no son a quien sirve la V1.

### 2.1. Turista nacional (primario) — `[DECIDIDO]`

Ecuatoriano, normalmente de Quito, Ambato o Latacunga, que va a Pujilí en el día
o en fin de semana, muchas veces alrededor de una fiesta o de la feria dominical.
Viene a la app a: ver qué hay para visitar, confirmar la fecha exacta de la
fiesta, y sacar la ruta para llegar. Idioma: español.

### 2.2. Turista extranjero (primario) — `[DECIDIDO]`

Llega normalmente por el circuito del Quilotoa y puede desviarse a Pujilí si sabe
que existe. Es la razón por la que el inglés no es una fase posterior sino un
requisito de la V1: el extranjero es justamente el que no tiene acceso al boca a
boca local. Idioma: inglés.

### 2.3. Residente de Pujilí (secundario) — `[PROPUESTA]`

Usa la app como agenda cultural del cantón (qué fiesta viene, dónde es la
procesión). No hay ninguna funcionalidad diseñada específicamente para él; se
beneficia del calendario igual que el turista.

### 2.4. Artesano y negocio local (no es usuario de la app) — `[DECIDIDO]`

Son **contenido**, no usuarios: aparecen en la app, no la operan. A futuro son
además la fuente de ingresos vía espacios publicitarios pagados, pero en la V1 no
tienen panel, ni autogestión, ni forma de darse de alta.

### 2.5. Municipio / GAD de Pujilí (no es usuario de la app) — `[PROPUESTA]`

Interlocutor institucional potencial para validar o aportar contenido. No hay
acuerdo ni conversación con ellos: ver "Preguntas abiertas".

---

## 3. Alcance

### 3.1. Entra en la V1 (MVP) — `[DECIDIDO]`

- Contenido informativo estático, empaquetado como assets locales.
- Bilingüe español / inglés desde el día uno, no por fases.
- Atractivos turísticos con ficha de detalle.
- Calendario de fiestas del cantón.
- Artesanos y gastronomía.
- Mapa con los atractivos ubicados.
- Costos mostrados en dólares estadounidenses (USD), moneda de Ecuador.

### 3.2. No entra en la V1, y por qué

| Fuera de alcance | Por qué | Marca |
|---|---|---|
| Backend propio / Firestore | El contenido de la V1 es pequeño, estable y cabe en JSON local. Un backend sin contenido que lo justifique es costo sin retorno. Se evalúa cuando existan fichas de negocios que cambien solas. | `[DECIDIDO]` |
| Reservas y venta de entradas | Requiere pasarela de pago, acuerdos con operadores y responsabilidad legal sobre la transacción. Se pospone a una V3 condicionada a que la app tenga tracción real. | `[DECIDIDO]` |
| Audioguías | Mismo motivo: V3, condicionado a tracción. | `[DECIDIDO]` |
| Modo offline explícito | V3. (Nota: al ser contenido local, buena parte de la app funcionará sin red de todos modos, salvo mapa e imágenes remotas.) | `[DECIDIDO]` |
| Publicidad activa (AdMob, espacios vendidos) | Es el modelo de ingresos de la V2. En la V1 no se monetiza. | `[DECIDIDO]` |
| Cuentas de usuario, login, registro | No hay nada que persistir por usuario en la V1. | `[PROPUESTA]` |
| Contenido generado por usuarios (reseñas, ratings, fotos) | Requiere backend y moderación. | `[PROPUESTA]` |
| Autogestión de artesanos/negocios | Ver 2.4. | `[DECIDIDO]` |

### 3.3. Fases posteriores — `[DECIDIDO]`

- **V2:** monetización. Banners de Google AdMob + venta directa de espacios
  publicitarios a negocios locales (hoteles, restaurantes, operadores).
- **V3 (condicionada a tracción):** reservas, audioguías, soporte offline.

---

## 4. Las pantallas, una por una

Seis pantallas diseñadas más Perfil, que sigue sin definirse. Todas están
dibujadas en `docs/MOCKS.html` y descritas aquí. El diseño es `[PROPUESTA]`:
fija la intención visual y la estructura, no es vinculante al píxel.

Los mockups originales (generados con Stitch) traían varios errores —barras de
navegación distintas en cada pantalla, nombres de atractivos inventados, símbolo
€, fechas de relleno, un pin duplicado, un botón de compra de entradas fuera de
alcance—. **Todos están corregidos en `MOCKS.html` y en las descripciones de
abajo.** Si en algún sitio aparece una imagen suelta de aquellos mocks, no es
referencia válida.

En `MOCKS.html` el estado de cada dato va marcado visualmente: subrayado
punteado para el dato de relleno que hay que verificar, recuadro terracota «V2»
para lo que no entra en la primera versión, recuadro gris para lo que sigue sin
decidirse.

### Barra de navegación real — `[DECIDIDO]`

Cinco tabs, iguales en toda la app: **Inicio · Explorar · Calendario · Mapa ·
Artesanos**.

El quinto tab era Perfil. Desde 2026-09-21 lo ocupa Artesanos (pregunta
resuelta nº 8) y los ajustes se abren desde la cabecera de Inicio (nº 1).
**En el código el cambio todavía no está hecho:** `ShellTab` sigue nombrando
el quinto tab `profile`.

---

### 4.1. Inicio (`home`) — tab **Inicio**

**Qué ve el usuario, de arriba abajo:**

1. **Header con el nombre de la app** ("Pujilí Vive") sobre una fotografía
   amplia del paisaje de Pujilí (campo, casas de teja, montañas).
2. **Buscador** superpuesto al header, con placeholder "Buscar experiencias…".
3. **Card de próximo evento**, montada sobre el borde inferior de la foto. Es la
   pieza más prominente de la pantalla: foto del evento a la izquierda,
   etiqueta "Próxima fiesta", el nombre del evento en grande ("Corpus Christi —
   Danzantes de Pujilí"), y una **cuenta regresiva en vivo** en tres bloques
   —días : horas : min— más un botón "Ver la fiesta". Se muestra como carrusel
   horizontal (asoma una segunda card a la derecha), es decir, más de un evento
   próximo.
4. **Sección "Qué visitar"** — carrusel horizontal de tarjetas pequeñas con foto,
   un icono de categoría en la esquina superior derecha, y el nombre debajo.
5. **Sección "Ruta artesanal"** — segundo carrusel horizontal, mismo formato,
   con talleres y oficios. Se distingue de la anterior por el color del pie de
   las tarjetas: verde en "Qué visitar", terracota en "Ruta artesanal".

**Esquema de layout:**

```
┌──────────────────────────────────────────┐
│              Pujilí Vive                 │  título
│   ┌────────────────────────────────┐     │
│   │ 🔍  Buscar experiencias...     │     │  search
│   └────────────────────────────────┘     │
│ ░░░░░ foto panorámica de Pujilí ░░░░░░░░ │
│ ░░┌────────────────────────────┐░░┌───── │
│ ░░│ [foto] Próxima fiesta      │░░│ (2ª  │  carrusel
│ ░░│        Corpus Christi      │░░│ card)│  de eventos
│ ░░│  ┌──┐ ┌──┐ ┌──┐            │░░│      │
│ ░░│  │03│:│14│:│35│            │░░│      │  countdown
│ ░░│  │dí││ho││mi│ [Ver la fiesta]│░░│     │
│ ░░│  └──┘ └──┘ └──┘            │░░│      │
│ ░░└────────────────────────────┘░░└───── │
│                                          │
│  Qué visitar                             │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌───         │
│  │ foto⌖│ │ foto⌂│ │ foto☷│ │            │  scroll →
│  │Laguna│ │Iglesi│ │Mercad│ │            │
│  │Quilot│ │Matriz│ │Indíge│ │            │
│  └──────┘ └──────┘ └──────┘ └───         │
│                                          │
│  Ruta artesanal                          │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌───         │
│  │ foto │ │ foto │ │ foto │ │            │  scroll →
│  │Taller│ │Tejedo│ │Taller│ │            │
│  │Cerámi│ │ Tigua│ │Máscar│ │            │
│  └──────┘ └──────┘ └──────┘ └───         │
├──────────────────────────────────────────┤
│  Inicio  Explorar  Calendario  Mapa  Perfil │
└──────────────────────────────────────────┘
```

**Acciones y a dónde llevan:**

| Acción | Destino | Marca |
|---|---|---|
| Tocar el buscador | Búsqueda global — **sin definir**, ver Preguntas abiertas | `[PROPUESTA]` |
| Tocar la card de evento o "Ver la fiesta" | Detalle del evento (Calendario) | `[PROPUESTA]` |
| Tocar una tarjeta de "Qué visitar" | Detalle de atractivo (4.3) | `[PROPUESTA]` |
| Tocar una tarjeta de "Ruta artesanal" | Detalle de artesano/plato — **formato sin definir** | `[PROPUESTA]` |
| Deslizar los carruseles | Scroll horizontal, sin navegación | `[PROPUESTA]` |

**Datos que necesita:** el próximo `FestivalEvent` por fecha (`startDate`) para
el countdown; un subconjunto de `Attraction` para "Qué visitar"; un subconjunto de
`ArtisanItem` para "Ruta Artesanal".

**Estados:** `[PROPUESTA]`
- *Vacío de eventos* (no hay ninguna fiesta futura en el dataset): la card de
  countdown se oculta y la pantalla arranca directamente en "Qué visitar". No se
  muestra una card vacía.
- *Error de carga*: mensaje corto con acción de reintento, en el lugar de la
  sección afectada, sin tumbar el resto de la pantalla.

---

### 4.2. Atractivos (`attractions`) — tab **Explorar**

Esta es la única feature ya implementada de punta a punta en el repo.

**Qué ve el usuario, de arriba abajo:**

1. **App bar** con botón de retroceso a la izquierda y el título "Atractivos"
   centrado.
2. **Fila de chips de filtro**, scroll horizontal, con el chip activo en relleno
   sólido y los inactivos en contorno: **Todos · Cultural · Religioso ·
   Naturaleza · Artesanía**. Por defecto "Todos".
3. **Lista vertical de tarjetas.** Cada tarjeta es una foto grande a sangre con
   esquinas redondeadas y un degradado oscuro en la parte inferior sobre el que
   se leen, en blanco: el **nombre** del atractivo, la **categoría** en línea
   secundaria, y la **distancia** alineada a la derecha ("2.5 km").
4. **Slot publicitario** al final de la lista: una tarjeta horizontal con borde,
   foto pequeña a la izquierda, nombre del anunciante, botón de acción
   ("Reservar Ahora") y la etiqueta "Publicidad" alineada a la derecha.

**Esquema de layout:**

```
┌──────────────────────────────────────────┐
│  ‹             Atractivos                │
│                                          │
│ (Todos) ( Cultural )( Religioso )( Nat…  │  chips, scroll →
│                                          │
│ ┌──────────────────────────────────────┐ │
│ │ ░░░░░░░░░ foto ░░░░░░░░░░░░░░░░░░░░░ │ │
│ │ Santuario del Niño de Isinche        │ │
│ │ Religioso                    2.5 km  │ │
│ └──────────────────────────────────────┘ │
│ ┌──────────────────────────────────────┐ │
│ │ ░░░░░░░░░ foto ░░░░░░░░░░░░░░░░░░░░░ │ │
│ │ Laguna del Quilotoa                  │ │
│ │ Naturaleza                    54 km  │ │
│ └──────────────────────────────────────┘ │
│ ┌──────────────────────────────────────┐ │
│ │  … (una card por atractivo)          │ │
│ └──────────────────────────────────────┘ │
│ ┌──────────────────────────────────────┐ │
│ ┆ [img] Nombre del anunciante         ┆ │
│ ┆       [ Ver más ]         Publicidad ┆ │  slot ads (V2)
│ └──────────────────────────────────────┘ │
├──────────────────────────────────────────┤
│  Inicio  Explorar  Calendario  Mapa  Perfil │
└──────────────────────────────────────────┘
```

**Acciones:**

| Acción | Destino | Marca |
|---|---|---|
| Tocar un chip | Filtra la lista en sitio por `category`. No navega. | `[DECIDIDO]` |
| Tocar una tarjeta | Detalle de atractivo (4.3) | `[DECIDIDO]` |
| Tocar el slot publicitario | Fuera de la app (web del anunciante) — solo desde V2 | `[DECIDIDO]` |

**Datos:** lista de `Attraction` con `name`, `category`, `photos[0]`, y una
distancia por atractivo.

**Estados:** `[PROPUESTA]`
- *Vacío por filtro*: "No hay atractivos en esta categoría" + acción para volver
  a "Todos". Nunca dejar la pantalla en blanco con los chips colgando.
- *Error de carga del JSON*: mensaje y botón de reintento a pantalla completa.
- No hay estado de "sin resultados de búsqueda" porque esta pantalla no tiene
  buscador propio.

**Advertencia sobre la distancia — `[PROPUESTA]`:** cada tarjeta muestra una
distancia, pero no se decidió si es un valor fijo desde el centro de Pujilí
guardado en el JSON o un cálculo contra la ubicación real del usuario. Ver
Preguntas abiertas; hasta resolverlo, no introducir un permiso de
geolocalización.

---

### 4.3. Detalle de atractivo (`attractions`, ruta de detalle) — sin tab propio

Se abre empujada sobre el tab desde el que se entró (Explorar, Inicio o Mapa).

**Qué ve el usuario, de arriba abajo:**

1. **Foto a sangre completa** ocupando el tercio superior, con un **botón de
   retroceso circular translúcido** superpuesto en la esquina superior izquierda.
2. **Panel de contenido** que sube sobre la foto con esquinas superiores
   redondeadas, y un pequeño adorno gráfico (cinta/banderín con motivo andino) en
   su esquina superior derecha.
3. **Nombre del atractivo** en grande.
4. **Línea de categoría**: "Categoría: …".
5. **Descripción** en párrafo, dos a cuatro líneas.
6. **Fila de tres datos prácticos**, separados por divisores verticales, cada uno
   con icono + etiqueta + valor:
   - 🕐 **Horario:** "9:00 - 18:00"
   - 💵 **Costo:** "Entrada libre"
   - 📍 **Ubicación:** "Pujilí, Cotopaxi"
7. **Botón primario ancho "Cómo llegar"** con icono de mapa.
8. **Galería horizontal de fotos** al pie, tarjetas cuadradas con scroll lateral.

**Esquema de layout:**

```
┌──────────────────────────────────────────┐
│ (‹)  ░░░░░░░ foto a sangre ░░░░░░░░░░░░░ │
│      ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ╭────────────────────────────────────╮   │
│ │                            ▚▚▞▞    │   │  adorno
│ │  Santuario del Niño de Isinche     │   │
│ │  Categoría: Religioso              │   │
│ │                                    │   │
│ │  Descripción en párrafo, dos a     │   │
│ │  cuatro líneas de texto…           │   │
│ │  ────────────────────────────────  │   │
│ │  🕐 Horario │ 💵 Costo │ 📍 Ubicación│   │
│ │  9:00-18:00 │ Entrada  │ Pujilí,   │   │
│ │             │ libre    │ Cotopaxi  │   │
│ │  ────────────────────────────────  │   │
│ │  ┌──────────────────────────────┐  │   │
│ │  │      Cómo llegar  🗺          │  │   │  CTA primario
│ │  └──────────────────────────────┘  │   │
│ │  ┌────┐ ┌────┐ ┌────┐ ┌──         │   │
│ │  │foto│ │foto│ │foto│ │           │   │  galería →
│ │  └────┘ └────┘ └────┘ └──         │   │
│ ╰────────────────────────────────────╯   │
├──────────────────────────────────────────┤
│  Inicio  Explorar  Calendario  Mapa  Perfil │
└──────────────────────────────────────────┘
```

**Acciones:**

| Acción | Destino | Marca |
|---|---|---|
| Botón de retroceso | Vuelve a la pantalla anterior | `[DECIDIDO]` |
| "Cómo llegar" | Lanza la **app de mapas del teléfono** con indicaciones hasta las coordenadas: Apple Maps en iOS, Google Maps en el resto. Da la ruta paso a paso real, cosa que un pin dentro de la app no puede. Decidido el 2026-09-17. | `[DECIDIDO]` |
| Tocar una foto de la galería | Visor a pantalla completa | `[PROPUESTA]` |

**Datos:** una `Attraction` completa: `name`, `category`, `description`,
`schedule`, `cost`, `locationLabel`, `latitude`, `longitude`, `photos[]`.

**Estados:** `[PROPUESTA]`
- Los campos `schedule` y `cost` no aplican a todos los atractivos (un mirador no
  tiene horario). Cuando falta un dato, **se oculta esa columna** en lugar de
  mostrar "—" o "No disponible".
- Sin fotos adicionales: se oculta la galería, no se deja el hueco.

---

### 4.4. Fiestas (`calendar`) — tab **Calendario**

`[DECIDIDO]` **Esta es la pantalla clave del producto.** Ver sección 8.

**Qué ve el usuario, de arriba abajo:**

1. **App bar** con retroceso, título "Fiestas" e icono de lupa a la derecha.
2. **Campo de búsqueda** ancho, placeholder "Buscar una fiesta…".
3. **Timeline vertical**: una línea continua recorre el eje izquierdo de la
   pantalla, con nodos por evento.
4. **Encabezado de mes** repetido a lo largo del scroll ("Junio 2027"), con el
   nombre del mes en dorado y el año en terracota. El año va en caja baja, no en
   versalitas.
5. **Tarjetas de evento** enganchadas a la línea. Hay **tres tratamientos**, y
   el que manda es el reloj (`[DECIDIDO]` 2026-09-21):
   - **Ocurriendo ahora**: tarjeta **blanca** con marco dorado, sombra, nodo
     grande en la línea, foto rectangular y la etiqueta "AHORA". Es el único
     caso que pinta blanco.
   - **Destacada y aún no empieza**: marco dorado **sin relleno**, nodo
     mediano. Distingue la importancia del evento de que esté ocurriendo, que
     son dos cosas distintas.
   - **Ya terminó**: la tarjeta se **atenúa** pero se queda en la lista.
   - **El resto**: sin borde, nodo pequeño, **foto circular**.
6. Los eventos siguen agrupados por mes a medida que se hace scroll. El bloque
   de fecha lleva **también la hora**, porque hay dos fiestas al día y el día
   solo ya no las distingue.

> **El blanco cambió de significado.** Antes lo ponía `isHighlighted` y era
> fijo en el JSON. Ahora significa "esto está pasando ahora mismo" y la
> pantalla se repinta sola cada 30 s, así que una fiesta pasa a blanca al
> llegar su hora y se atenúa al terminar sin que nadie toque nada.

**Esquema de layout:**

```
┌──────────────────────────────────────────┐
│  ‹            Fiestas                🔍  │
│  ┌────────────────────────────────────┐  │
│  │ Buscar una fiesta…                 │  │
│  └────────────────────────────────────┘  │
│                                          │
│  Junio 2027                              │  header de mes
│  │                                       │
│ ╭◉╮╔══════════════════════════════════╗  │  destacado
│ ╰─╯║ [foto] ┌────┐ Corpus Christi:    ║  │
│  │ ║        │ 27 │ Danzantes de Pujilí ║  │
│  │ ║        │JUN │ Celebración princi- ║  │
│  │ ║        └────┘ pal con danzantes…  ║  │
│  │ ╚══════════════════════════════════╝  │
│ ╭◉╮╔══════════════════════════════════╗  │  destacado
│ ╰─╯║ [foto] ┌────┐ La Octava de       ║  │
│  │ ║        │ 4  │ Corpus Christi      ║  │
│  │ ║        │JUL │ Culminación de la…  ║  │
│  │ ╚══════════════════════════════════╝  │
│  │                                       │
│  Julio 2027                              │
│  ●   (foto)  ┌────┐ Fiesta de la        │  normal
│  │   ( ○  )  │ 16 │ Virgen del Carmen   │
│  │           │JUL │ Feria gastronómica… │
│  │                                       │
│  Agosto 2027                             │
│  ●   (foto)  ┌────┐ Fiesta de           │  normal
│  │   ( ○  )  │ 10 │ San Lorenzo         │
│  │           │AGO │ Desfile cívico…     │
├──────────────────────────────────────────┤
│  Inicio  Explorar  Calendario  Mapa  Perfil │
└──────────────────────────────────────────┘
```

**Acciones:**

| Acción | Destino | Marca |
|---|---|---|
| Escribir en el buscador | Filtra la lista en sitio por título/descripción | `[PROPUESTA]` |
| Tocar una tarjeta de evento | Detalle del evento — **pantalla no diseñada**, ver Preguntas abiertas | `[PROPUESTA]` |
| Scroll | Avanza por meses | `[DECIDIDO]` |

**Datos:** lista de `FestivalEvent` ordenada por fecha ascendente y agrupada por
mes: `title`, `description`, `startDate`, `photo`, `isHighlighted`.

**Estados:** `[PROPUESTA]`
- *Sin resultados de búsqueda*: "No encontramos eventos con ese nombre" y acción
  para limpiar el filtro.
- *Eventos pasados*: sin definir si se ocultan, se atenúan o se muestran en una
  sección aparte. Ver Preguntas abiertas.

---

### 4.5. Mapa (`map`) — tab **Mapa**

> **Implementada (2026-09-21)**, con tres diferencias respecto a lo que
> sigue, todas por falta de material y no por criterio:
>
> 1. **Una cuarta opción en el selector, "Todas"**, y es la inicial. El
>    diseño dibuja tres rutas, pero `Attraction` tiene cuatro categorías:
>    la Plaza e Iglesia Matriz y la Feria Dominical son `cultural` y sin
>    esa opción quedarían invisibles en el mapa.
> 2. **Pines de color, no ilustrados.** El cántaro, la cúpula y la
>    montaña necesitan iconos dibujados que no existen.
> 3. **Sin distancias** en las filas del sheet: no hay campo y depende de
>    la pregunta abierta nº 9.
>
> Y **falta cargar la API key** (`docs/MAPS_SETUP.md`). Sin ella el área
> del mapa sale en blanco; el sheet sigue funcionando.

**Qué ve el usuario, de arriba abajo:**

1. **App bar** con retroceso y título "Mapa".
2. **Selector de rutas temáticas**: un control segmentado de tres opciones dentro
   de una píldora con borde — **Ruta del artesano · Ruta religiosa · Ruta
   natural**. La activa va en relleno sólido.
3. **Mapa a pantalla completa** ocupando el resto, con **pines personalizados**:
   cada pin es una gota con un icono ilustrado dentro (cántaro de cerámica para
   artesanía, cúpula para religioso, montaña+árbol para naturaleza) y una
   **etiqueta de texto** con el nombre del lugar justo debajo del pin.
4. **Bottom sheet arrastrable** "Explorar Lugares", con asa superior, que cubre
   aproximadamente la mitad inferior en su estado medio:
   - Lista de lugares (sin buscador ni icono de filtros propios: el selector de
     rutas de arriba ya cumple esa función).
   - Lista de lugares: miniatura cuadrada a la izquierda, nombre en dos líneas,
     línea secundaria "Categoría · distancia" (p. ej. "Artesanía · 0.5 km"), y
     chevron ">" a la derecha.

**Esquema de layout:**

```
```
┌──────────────────────────────────────────┐
│  ‹               Mapa                    │
│ ┌──────────────────────────────────────┐ │
│ │(Ruta del artesano)│Ruta religiosa│Ruta│ │  segmentado
│ └──────────────────────────────────────┘ │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ │
│ ▒   ╭─╮                      ╭─╮      ▒ │
│ ▒   │⚱│                      │⛰│      ▒ │  pin = gota
│ ▒   ╰┬╯                      ╰┬╯      ▒ │  con icono
│ ▒ [Talleres de   ╭─╮   [Mirador Cruz] ▒ │  + etiqueta
│ ▒  cerámica]     │⛪│   [del Calvario] ▒ │
│ ▒                ╰┬╯                  ▒ │
│ ▒  ╭─╮    [Plaza e Iglesia]  ╭─╮      ▒ │
│ ▒  │☷│      Pujilí           │✝│      ▒ │
│ ▒  ╰┬╯                       ╰┬╯      ▒ │
│ ▒ [Feria dominical]   [Santuario Niño] ▒│
│ ┌──────────────────────────────────────┐ │
│ │              ▁▁▁▁                    │ │  asa
│ │  Explorar lugares                    │ │
│ │  [img] Talleres de cerámica       ›  │ │
│ │        de La Victoria                │ │
│ │        Artesanía · 6 km              │ │
│ │  ─────────────────────────────────   │ │
│ │  [img] Santuario del Niño de      ›  │ │
│ │        Isinche                       │ │
│ │        Religioso · 2,5 km            │ │
│ │  ─────────────────────────────────   │ │
│ │  [img] Plaza e Iglesia Matriz     ›  │ │
│ └──────────────────────────────────────┘ │
├──────────────────────────────────────────┤
│  Inicio  Explorar  Calendario  Mapa  Perfil │
└──────────────────────────────────────────┘
```

**Acciones:**

| Acción | Destino | Marca |
|---|---|---|
| Tocar una ruta temática | Filtra pines y lista del sheet a esa ruta | `[PROPUESTA]` |
| Tocar un pin | **Sin decidir**: expandir el sheet en ese lugar, o mostrar una card flotante. Ver Preguntas abiertas. | `[PROPUESTA]` |
| Arrastrar el sheet | Tres estados: colapsado / medio / expandido | `[PROPUESTA]` |
| Tocar una fila del sheet | Detalle de atractivo (4.3) | `[PROPUESTA]` |

**Datos:** `Attraction` con `latitude`/`longitude` obligatorias, `category` para
el icono del pin, y pertenencia a una o más `ThematicRoute`.

**Estados:** `[PROPUESTA]`
- *Sin permiso de ubicación*: el mapa se centra en el casco urbano de Pujilí y
  las distancias se ocultan. La app debe ser usable sin conceder ubicación.
- *Sin red*: el mapa no carga tiles; mostrar un aviso dentro del área del mapa
  pero **mantener el sheet con la lista funcionando**, ya que sus datos son
  locales.
- *Ruta sin lugares*: sheet con mensaje vacío en vez de lista en blanco.

---

### 4.6. Artesanos y comida (`artisans`) — tab **Artesanos**

`[DECIDIDO]` Ocupa el quinto tab, el que era Perfil (pregunta resuelta nº 8).
Lo que sigue bloqueándola no es la navegación sino el **contenido**: no hay
fotos ni contactos reales levantados en campo (pregunta abierta nº 18).

**Qué ve el usuario, de arriba abajo:**

1. **App bar** con retroceso y un **icono de filtro (embudo)** a la derecha.
2. **Título grande** alineado a la izquierda, dentro del cuerpo y no en la app
   bar: "Artesanos y comida" — acortado respecto al diseño original para que
   quepa en una línea en español y en inglés.
3. **Grid de dos columnas** de tarjetas. Cada tarjeta: foto arriba con esquinas
   redondeadas, debajo el **nombre** en color terracota y en negrita, una
   **descripción de una o dos líneas**, y —solo en algunas— una **línea de
   ubicación** con icono de pin ("Pujilí, Cotopaxi", "Pujilí Centro"). Las
   tarjetas tienen alturas distintas según si llevan ubicación o no.
4. **Franja promocional fija al pie**, sobre la barra de navegación: fondo
   dorado con patrón textil andino, texto en dos líneas y un botón redondeado
   "Ver fiestas" que lleva al calendario. **No promociona venta de entradas**:
   eso está fuera de alcance (sección 3.2) y el diseño original lo prometía por
   error.

**Contenido que muestra el diseño** (mezcla oficios, productos y platos en un
mismo grid, sin separarlos): talleres de alfarería, talladores de máscaras,
hornado, cuy asado, tejidos, cerámica decorativa. **Todo es relleno**: no hay
fotos ni contactos reales levantados, y ese es el bloqueante de esta feature.

**Esquema de layout:**

```
┌──────────────────────────────────────────┐
│  ‹                                    ▽  │  filtro
│  Artesanos y comida                      │
│  ┌─────────────────┐ ┌─────────────────┐ │
│  │ ░░░░ foto ░░░░░ │ │ ░░░░ foto ░░░░░ │ │
│  │ Talleres de     │ │ Talladores de   │ │
│  │ Alfarería       │ │ Máscaras        │ │
│  │ Descubre la     │ │ Visita a los    │ │
│  │ técnica ances-  │ │ artesanos que   │ │
│  │ tral…           │ │ dan vida al…    │ │
│  │ 📍 Pujilí, Cot. │ │ 📍 Pujilí Centro│ │
│  └─────────────────┘ └─────────────────┘ │
│  ┌─────────────────┐ ┌─────────────────┐ │
│  │ ░░░░ foto ░░░░░ │ │ ░░░░ foto ░░░░░ │ │
│  │ Hornado         │ │ Cuy Asado       │ │
│  │ Tradicional     │ │ Andino          │ │
│  │ Saborea el      │ │ Prueba el man-  │ │
│  │ auténtico plato…│ │ jar ceremonial… │ │
│  └─────────────────┘ └─────────────────┘ │
│  ┌─────────────────┐ ┌─────────────────┐ │
│  │  … (grid sigue) │ │                 │ │
│  └─────────────────┘ └─────────────────┘ │
│ ▞▚▞ Fiesta del Danzante              ┌──┐│  franja
│ ▚▞▚ Junio en Pujilí. Mira el programa.│Ver││  promo
├──────────────────────────────────────────┤
│  Inicio  Explorar  Calendario  Mapa  Perfil │
└──────────────────────────────────────────┘
```

**Acciones:**

| Acción | Destino | Marca |
|---|---|---|
| Tocar una tarjeta | Detalle de artesano/plato — **pantalla no diseñada** | `[PROPUESTA]` |
| Icono de filtro | **Sin definir**: probablemente separar artesanía de gastronomía | `[PROPUESTA]` |
| "Ver fiestas" de la franja promocional | Tab Calendario | `[PROPUESTA]` |

**Datos:** lista de `ArtisanItem`: `name`, `shortDescription`, `photo`,
`locationLabel` (opcional), `type`.

**Estados:** `[PROPUESTA]` vacío por filtro y error de carga, igual que 4.2.

---

### 4.7. Ajustes (`settings`) — **ya no es un tab**

`[DECIDIDO]` (2026-09-21) Perfil deja de ser un tab: sin cuentas de usuario no
hay perfil que mostrar. Su slot en la barra pasa a Artesanos (§4.6) y lo que
sobrevive es una pantalla de **ajustes mínimos** —idioma, acerca de,
contacto— que se abre desde un icono de engranaje en la cabecera de Inicio.

Favoritos **no** entra: es la pregunta abierta nº 2 y necesita persistencia
local, que la app todavía no tiene.

En el código el parche sigue en pie: el quinto tab se llama `profile` y apunta
a `ArtisansPage`. Deshacerlo es parte de esta decisión, no un arreglo aparte.

---

## 5. Navegación

`[DECIDIDO]` Shell único con barra inferior de cinco tabs. Cada tab mantiene su
propia pila; las pantallas de detalle se empujan **dentro** del tab activo, así
que el tab no cambia al abrir un detalle.

```
                    ┌──────────────┐
                    │  MainShell   │
                    └──────┬───────┘
     ┌──────────┬──────────┼──────────┬──────────┐
     │          │          │          │          │
  ┌──▼───┐  ┌───▼────┐ ┌───▼─────┐ ┌──▼──┐  ┌────▼─────┐
  │Inicio│  │Explorar│ │Calendario│ │Mapa │  │Artesanos │
  └──┬───┘  └───┬────┘ └───┬─────┘ └──┬──┘  └──────────┘
     │          │          │          │      (bloqueada: sin contenido)
     │          │          │          │
     │      ┌───▼──────────▼──────────▼────┐
     └─────►│  Detalle de atractivo (4.3)  │
            └───────────┬──────────────────┘
                        │ "Cómo llegar" → app de mapas del teléfono
                        ▼
                   (Mapa o app nativa)

  Inicio ──(engranaje)─────► Ajustes (4.7)          [pendiente]
  Inicio ──("Ver la fiesta")─► Detalle de evento     ✅ hecho
  Calendario ──(tarjeta)────► Detalle de evento     ✅ hecho
  Inicio ──(Ruta Artesanal)─► Detalle de artesano   [pantalla no diseñada]
```

`[PROPUESTA]` El **detalle de atractivo es el nodo de convergencia** de la app:
se llega desde Inicio, desde Explorar y desde el Mapa. Conviene que sea una única
ruta parametrizada por id, no tres implementaciones.

---

## 6. Modelo de datos

`[DECIDIDO]` Todo el contenido de la V1 vive en assets JSON locales. No hay
backend.

### 6.1. Bilingüismo

`[DECIDIDO]` Dos mecanismos distintos, no confundirlos:

- **Texto de interfaz** (etiquetas, botones, mensajes de estado): vive en los
  `.arb` y sale por `gen-l10n`. Nada hardcodeado.
- **Texto de contenido** (nombres y descripciones de atractivos, eventos,
  artesanos): vive en el JSON, con cada campo bilingüe duplicado `es`/`en` y
  resuelto por el helper `LocalizedText` ya existente en el repo.

En las tablas de abajo, los campos bilingües van marcados **⇄**.

### 6.2. `Attraction` — **YA EXISTE** en el repo

`[DECIDIDO]` Implementada de punta a punta (entity, model, datasource desde
`assets/data/attractions.json`, repository, usecase, BLoC con carga y filtro por
categoría). Contiene los seis atractivos acordados con fotos reales.

**Importante:** la lista de campos de abajo es la acordada conceptualmente en su
momento; **los nombres exactos deben leerse del `attractions.json` y de la entity
reales del repo**, que son la fuente de verdad. No renombrar nada para que cuadre
con este documento.

| Campo | Tipo | Bilingüe | Notas |
|---|---|---|---|
| `id` | String | | |
| `name` | LocalizedText | ⇄ | |
| `description` | LocalizedText | ⇄ | Descripción corta |
| `category` | AttractionCategory | | Ver 6.3 |
| `latitude` | double | | |
| `longitude` | double | | |
| `schedule` | LocalizedText? | `[DECIDIDO]` ⇄ | Opcional; no todo atractivo tiene horario. Si falta, el detalle oculta la columna |
| `cost` | LocalizedText? | `[DECIDIDO]` ⇄ | Opcional, en USD. "Entrada libre" es un valor válido, no una ausencia |
| `locationLabel` | LocalizedText? | ⇄ | "Pujilí, Cotopaxi" |
| `photos` | List\<String\> | | La primera es la de portada |

**Contenido acordado — los seis atractivos:** `[DECIDIDO]`
Santuario del Niño de Isinche · Plaza e Iglesia Matriz · Mirador Cruz del
Calvario · Talleres de cerámica de La Victoria · Feria dominical · Laguna del
Quilotoa (como destino cercano, fuera del cantón).

### 6.3. `AttractionCategory` — **YA EXISTE** (enumerado)

`[DECIDIDO]` Valores visibles en la UI: **Cultural, Religioso, Naturaleza,
Artesanía**, más "Todos" como estado de filtro (no es una categoría, es la
ausencia de filtro).

### 6.4. `FestivalEvent` — **NUEVA**

`[PROPUESTA]` en sus campos; `[DECIDIDO]` en que la feature existe y es
prioritaria.

| Campo | Tipo | Bilingüe | Notas |
|---|---|---|---|
| `id` | String | | |
| `title` | LocalizedText | ⇄ | |
| `description` | LocalizedText | ⇄ | Una o dos líneas |
| `startDate` | DateTime | | **Con hora.** Alimenta el countdown de Inicio |
| `endDate` | DateTime? | | **Con hora.** `null` = dura el día entero, que era la semántica cuando las fechas no llevaban hora |
| `photo` | String | | |
| `isHighlighted` | bool | | "Esta fiesta importa más que las otras". Marco dorado sin relleno; **ya no pinta la tarjeta de blanco** (ver 4.4) |
| `locationLabel` | LocalizedText? | ⇄ | Dónde ocurre |

**Estado en vivo.** La entidad calcula en qué punto está respecto al reloj:
`upcoming`, `inProgress` o `past`. Es lo que decide el aspecto de la tarjeta
(ver 4.4) y lo que usa Inicio para no llamar "próximo evento" a algo que ya
terminó.

> ### ⚠️ El dataset actual es una simulación
>
> `assets/data/festival_events.json` es hoy un **programa inventado de 15
> días** —30 fiestas, dos por día, del 21 de septiembre al 5 de octubre de
> 2026— hecho para poder ver el comportamiento en vivo sin esperar meses.
>
> **Las fiestas reales del cantón son dos al año:** el **Corpus Christi en
> junio** y las **cantonales en octubre**. Antes de publicar hay que
> sustituir este programa por el real, con fechas verificadas.
>
> Como las fechas son fijas y el tiempo pasa, el programa envejece: dentro de
> unas semanas todas sus fiestas estarán atenuadas. Es esperado. Ningún test
> depende de la fecha de hoy, precisamente para que eso no ponga el CI en
> rojo.

**Ojo con el Corpus Christi:** es fiesta móvil, su fecha depende de la Pascua. El
dataset no puede asumir un día fijo anual.

### 6.5. `ArtisanItem` — **NUEVA**

`[PROPUESTA]` Cubre en una sola entidad talleres, productos artesanales y platos
típicos, porque así los mezcla la pantalla (4.6).

| Campo | Tipo | Bilingüe | Notas |
|---|---|---|---|
| `id` | String | | |
| `name` | LocalizedText | ⇄ | |
| `shortDescription` | LocalizedText | ⇄ | Una o dos líneas |
| `photo` | String | | |
| `type` | ArtisanItemType | | `craft` / `food` — alimenta el filtro |
| `locationLabel` | LocalizedText? | ⇄ | Opcional; algunas tarjetas no lo muestran |
| `latitude` / `longitude` | double? | | Solo si debe aparecer en el mapa |

**Advertencia de contenido — `[DECIDIDO]`:** no hay fotos ni contactos reales de
artesanos; hay que levantarlos en campo. Cualquier dato de artesanos en el repo
hoy es de relleno.

### 6.6. `ThematicRoute` — **NUEVA**

`[PROPUESTA]`

| Campo | Tipo | Bilingüe | Notas |
|---|---|---|---|
| `id` | String | | `artisan` / `religious` / `nature` |
| `name` | LocalizedText | ⇄ | "Ruta del artesano", etc. |
| `placeIds` | List\<String\> | | Referencias a `Attraction.id` y/o `ArtisanItem.id` |

Sin decidir si la ruta es solo un filtro de pines o un recorrido ordenado con
trazado sobre el mapa. Ver Preguntas abiertas.

### 6.7. `AdPlacement` — **NUEVA, solo V2**

`[PROPUESTA]` No implementar en la V1. Se documenta porque dos pantallas ya
reservan el espacio visual (4.2 y 4.6) y conviene no diseñar layouts que luego no
tengan dónde meterlo.

| Campo | Tipo | Notas |
|---|---|---|
| `id` | String | |
| `sponsorName` | String | Nombre propio, no se traduce |
| `photo` | String | |
| `ctaLabel` | LocalizedText ⇄ | "Reservar Ahora" |
| `targetUrl` | String | |
| `screen` | enum | Dónde se muestra |

Debe llevar siempre la etiqueta visible "Publicidad" / "Ad".

### 6.8. `LocalizedText` — **YA EXISTE**

`[DECIDIDO]` Helper del repo que envuelve un par `{es, en}` y resuelve según el
locale activo.

---

## 7. Decisiones de diseño ya tomadas

### 7.1. Paleta — `[DECIDIDO]`

Inspirada en el traje del **Danzante de Pujilí**, que es el símbolo del cantón.
No es una paleta genérica de app de turismo: es el motivo por el que la app se
ve pujilense y no intercambiable.

| Rol | Hex | Uso |
|---|---|---|
| Terracota | `#B5502E` | Color primario. Títulos, CTAs, chip activo, bloques de fecha |
| Dorado | `#C8993A` | Acentos, encabezados de mes, bordes decorativos |
| Verde profundo | `#1F4A3A` | Secundario. Títulos de sección, contenedores oscuros |
| Crema | `#F6EBD3` | Fondo de toda la app |

El fondo crema en vez de blanco es deliberado: quita el aire clínico y da
calidez sin competir con la fotografía.

### 7.2. Tipografía — `[PROPUESTA]`

Sans-serif moderna y legible; títulos de sección en peso fuerte y tamaño alto,
cuerpo en peso regular. **No se eligió una familia concreta.** Ver Preguntas
abiertas.

### 7.3. Lenguaje visual — `[PROPUESTA]`

- Tarjetas con esquinas bien redondeadas y sombras suaves.
- Fotografía a sangre, generosa, protagonista: la foto vende, el texto acompaña.
- Motivos textiles andinos como **adorno de borde** (esquinas, franjas, bandas
  laterales), nunca como fondo de contenido legible.
- Iconos ilustrados y cálidos en los pines del mapa, no los marcadores por
  defecto de Google Maps.
- **Explícitamente evitado:** el look institucional / de folleto turístico
  municipal. Esa fue una restricción de diseño desde el inicio.

### 7.4. Tono de los textos — `[PROPUESTA]`

El diseño establece un patrón consistente: descripciones de **una o dos líneas**
en **segunda persona con verbo en imperativo** — "Descubre la técnica ancestral
de los maestros alfareros", "Saborea el auténtico plato de cerdo asado en leña",
"Prueba el manjar ceremonial de la región", "Abrígate con la lana de oveja de los
Andes". Invita, no describe. Cero adjetivos de folleto ("maravilloso",
"inolvidable"). Los títulos son el nombre real del lugar o del plato, sin
adornos.

### 7.5. Idioma y moneda — `[DECIDIDO]`

- Bilingüe ES/EN desde el día uno. El inglés **no** es una fase posterior: el
  turista extranjero es un usuario primario.
- Todos los costos en **USD** (moneda oficial de Ecuador).

### 7.6. Navegación unificada — `[DECIDIDO]`

Una sola barra inferior para toda la app, definida en el shell, idéntica en las
cinco secciones. Las pantallas de detalle se empujan dentro del tab activo, así
que el tab no cambia al abrir un detalle.

### 7.7. Método de trabajo — `[DECIDIDO]`

Cuando iterar sobre el diseño deja de aportar, se corrige directamente en código.
El diseño fija intención, no es contrato: `MOCKS.html` describe la composición,
no unas medidas que haya que reproducir al píxel.

---

## 8. Prioridad

`[DECIDIDO]` **El diferenciador principal del producto es el Calendario de
Fiestas**, con la cuenta regresiva al Corpus Christi en la pantalla de Inicio.
Ninguna app turística existente del mercado ecuatoriano ofrece un calendario vivo
de fiestas de un cantón. Lo demás —lista de atractivos, mapa, fichas— es paridad
competitiva: necesario para no verse incompleto, pero no es la razón por la que
alguien se descarga la app. Si hay que recortar, se recorta de abajo hacia
arriba de esta lista, nunca el calendario.

Estado a 2026-09-21. Solo queda Artesanos, y no por código: le falta el
contenido de campo (pregunta abierta nº 18).

| # | Feature | Estado | Por qué esa posición | Marca |
|---|---|---|---|---|
| 1 | **Calendar** (calendario de fiestas) | ✅ Completa, con detalle de evento | El diferenciador. Es el contenido que nadie más tiene y el que justifica la app | `[DECIDIDO]` |
| 2 | **Home** con countdown al próximo evento | ✅ Completa | Es el escaparate del diferenciador. Un calendario que no se ve al abrir la app no diferencia nada | `[PROPUESTA]` |
| 3 | **Attractions** (lista + detalle) | ✅ Completa | Ya hecha; es la plantilla arquitectónica del resto | `[DECIDIDO]` |
| 4 | **Map** con pines y rutas temáticas | ✅ Hecha — **falta la API key** | Alto valor de uso ("cómo llego"), pero es la más cara: API key, estilo, permisos, rendimiento | `[PROPUESTA]` |
| 5 | **Artisans** (artesanos y gastronomía) | 🟡 Scaffold vacío, ya con tab asignado (nº 8) | Bloqueada por contenido real: sin fotos ni contactos levantados en campo no hay pantalla que valga | `[PROPUESTA]` |
| 6 | ~~**Profile**~~ → **Ajustes** | ✅ Hecha; ya no es tab | Sin cuentas de usuario, su contenido es mínimo. No puede bloquear a nadie | `[DECIDIDO]` |
| 7 | **Ads** (AdMob + espacios vendidos) | No empezada | Es V2 por definición. Monetizar antes de tener usuarios es ruido | `[DECIDIDO]` |

`[DECIDIDO]` **Patrón de implementación obligatorio:** cada feature nueva replica
capa por capa el patrón de `attractions` (entity → model → datasource local desde
JSON → repository → usecase → BLoC → páginas y widgets). La consistencia
arquitectónica entre features es una decisión explícita, no una casualidad.

---

## 9. Preguntas abiertas

Todo lo que quedó sin decidir. **Preferir preguntar antes que rellenar.**

### Producto y alcance

1. ~~¿Qué contiene el tab **Perfil**?~~ **Resuelta (2026-09-21):** Perfil
   **deja de ser un tab**. Su slot en la barra pasa a Artesanos (ver nº 8) y lo
   que queda —**ajustes mínimos**: idioma, acerca de, contacto— se abre desde un
   icono de engranaje en la cabecera de Inicio. Sin cuentas de usuario no hay
   perfil que mostrar, y un tab de cinco no se gasta en tres ajustes. Favoritos
   sigue fuera: es la nº 2 y no se ha decidido. **Pendiente de implementar.**
2. ¿Hay **favoritos / guardados**? Un diseño temprano mostraba un tab
   "Guardados" que se descartó junto con su barra, pero nunca se decidió si la
   funcionalidad en sí entra o no.
3. ¿Existe **búsqueda global** desde Inicio? El buscador está dibujado con
   placeholder "Buscar experiencias…", pero no se definió qué indexa
   (¿atractivos? ¿eventos? ¿artesanos? ¿todo?) ni cómo se presentan los
   resultados.
4. ~~¿Qué pasa con los **eventos pasados** en el calendario?~~ **Resuelta
   (2026-09-21):** se **atenúan** y se quedan en la lista. Ocultarlos vaciaría
   el calendario según avanza la fiesta y no dejaría volver a consultar lo que
   hubo; agruparlos aparte rompería el orden cronológico, que es lo que hace
   legible una línea de tiempo.
5. ¿Se involucra al **Municipio / GAD de Pujilí** como fuente o validador de
   contenido? No hay contacto ni acuerdo.

### Pantallas faltantes

6. ~~**Detalle de evento**: ¿reutiliza el layout del detalle de atractivo?~~
   **Resuelta (2026-09-21):** sí, lo reutiliza. El armazón común (portada,
   panel crema, cinta, fila de datos) se extrajo a
   `lib/core/widgets/detail_layout.dart` y lo comparten las dos pantallas.
   Cambia lo que muestra: fecha y ubicación en vez de horario, costo y
   ubicación; píldora dorada si la fiesta es destacada; y **sin botón "Cómo
   llegar"**, porque `FestivalEvent` no tiene coordenadas y una ruta hacia un
   punto inventado es peor que no ofrecerla. **Implementada.**
7. **Detalle de artesano / plato**: mismo caso desde el grid de Artesanos.
8. ~~**¿En qué tab vive Artesanos y Gastronomía?**~~ **Resuelta (2026-09-21):**
   **ocupa el slot del tab Perfil**, que se queda sin contenido propio (nº 1).
   De las tres opciones era la única que no tocaba una feature ya terminada:
   meterla en Explorar mezclaba dos modelos de datos en una pantalla, y
   convertir Explorar en un hub rehacía la navegación de `attractions`. Además
   el parche del scaffold ya apuntaba ahí, así que deshacerlo y decidirlo son
   el mismo trabajo. **Pendiente de implementar.**

### Comportamiento

9. **Distancias**: ¿son valores fijos desde el centro de Pujilí (dato en el JSON)
   o calculadas desde la ubicación real del usuario? Esto decide si la app pide
   permiso de geolocalización, lo cual cambia el onboarding. **Sigue abierta**:
   el mapa ya está hecho y sus filas muestran solo la categoría, sin distancia.
   La app no pide ubicación.
10. ~~**"Cómo llegar"**: ¿abre el tab Mapa centrado en el atractivo, o lanza la app
    de mapas nativa con las coordenadas?~~ **Resuelta (2026-09-17):** lanza la
    app de mapas del teléfono. Ver 4.3.
11. **Rutas temáticas**: ¿son solo un filtro de pines, o un recorrido ordenado con
    trazado dibujado sobre el mapa? El nombre "Ruta" sugiere lo segundo; el
    diseño solo resuelve lo primero. **Implementado como filtro** (2026-09-21),
    que es lo único que el diseño resuelve; si además debe ser un recorrido
    dibujado, sigue sin decidirse y necesitaría una entidad `ThematicRoute`
    con datos, no el enumerado que hay hoy.
12. ~~**Tocar un pin**: ¿expande el sheet, muestra una card flotante, o navega
    al detalle?~~ **Resuelta (2026-09-21):** ninguna de las tres. Abre la
    ventana de información nativa de Google Maps, con el nombre y la
    ubicación. Es la opción que no inventa interfaz: las tres del diseño
    seguían sin decidirse y cualquiera de ellas habría sido una elección a
    ciegas. Si más adelante se quiere una, esta no estorba.
13. **Icono de filtro** en Artesanos: lo más probable es que separe artesanía de
    comida, pero no está acordado. (En Mapa se retiró: duplicaba el selector de
    rutas.)

### Diseño

14. **Familia tipográfica** concreta. Solo se decidió "sans-serif moderna y
    legible".
15. **Modo oscuro**: no se habló. La paleta crema/terracota no tiene equivalente
    oscuro definido.
16. **Tratamiento visual de eventos destacados** (`isHighlighted`): el diseño lo
    resuelve con doble marco, medallón sobre la línea de tiempo y foto
    rectangular frente a foto circular. **Parcialmente resuelta
    (2026-09-21):** esa ornamentación (relleno blanco, foto rectangular, nodo
    grande) pasó a significar "ocurriendo ahora"; lo destacado se quedó con un
    marco dorado sin relleno. Si el medallón con motivo de cáliz/sol se dibuja
    o no sigue abierto: necesita un icono que no existe.
17. **Estilo del mapa**: para acercarse al diseño haría falta un *map style*
    JSON personalizado sobre Google Maps. No se decidió si vale la pena el esfuerzo o
    se usa el estilo por defecto. **Hoy usa el estilo por defecto**, que es lo
    que se ve mientras no se decida.

### Contenido

18. **Fotos y datos verificados** de los artesanos: no existen, hay que
    levantarlos en campo. Es el bloqueante real de la feature de Artesanos.
19. **Fechas del calendario**: el Corpus Christi es fiesta móvil. ¿Se calcula la
    fecha, se actualiza el JSON cada año, o se mueve el contenido a Remote Config
    para poder cambiarlo sin publicar una versión nueva?
20. **Traducción al inglés del contenido**: los `.arb` cubren la interfaz, pero
    ¿quién traduce y valida las descripciones de contenido? No se decidió si es
    traducción propia o revisada por alguien.
```
