# Roadmap — Pujilí Vive

> Qué estamos haciendo y qué sigue. El **cómo** está en
> [`project_rules/`](../project_rules/); el **estado** en
> [`ARQUITECTURA.md`](./ARQUITECTURA.md).

El orden lo manda la prioridad de [`CONCEPTO.md`](./CONCEPTO.md) §8:
calendario → inicio → atractivos → **mapa** → artesanos → perfil → ads (V2).

## Fase 0 — MVP (hecho)
- [x] Clean Architecture + BLoC con `attractions` como plantilla.
- [x] Shell con navegación inferior unificada (5 tabs).
- [x] i18n ES/EN desde los `.arb`.
- [x] 6 atractivos en `assets/data/attractions.json`.
- [x] Higiene de repo: políticas, CI, project_rules.

## Fase 1 — Contenido y mapa
- [x] Reemplazar el placeholder de `map_page.dart` por `GoogleMap` con pines
      de los atractivos, selector de rutas temáticas y sheet "Explorar
      lugares".
- [ ] **Cargar la Google Maps API key** (ver [`MAPS_SETUP.md`](./MAPS_SETUP.md)).
      Sigue sin poner: `TU_GOOGLE_MAPS_API_KEY_IOS` en
      [`AppDelegate.swift`](../ios/Runner/AppDelegate.swift) y `MAPS_API_KEY`
      ausente de `android/local.properties`. **Es lo único que separa al mapa
      de funcionar:** el código está hecho y el build no se rompe sin ella,
      pero el área del mapa sale en blanco. El sheet con la lista sí funciona,
      porque lee datos locales.
- [ ] Pines ilustrados (cántaro, cúpula, montaña) en vez de los marcadores de
      color de ahora. Necesita iconos dibujados que no existen.
- [x] Fotos reales de Pujilí en `assets/images/` (comprimidas).
- [ ] Datos prácticos verificados (horarios, cómo llegar, contactos).
      Bloqueado por trabajo de campo, igual que las coordenadas de abajo.

## Fase 2 — Features scaffold → completas
- [x] `calendar`: fiestas y eventos (diferenciador clave).
- [x] `home`: contenido de bienvenida real, con cuenta regresiva a la próxima
      fiesta y carrusel "Qué visitar". Sin buscador (pregunta abierta nº 3) ni
      carrusel artesanal (bloqueado por contenido).
- [x] `attractions`: detalle con datos prácticos y "Cómo llegar", y un
      `Navigator` por tab para abrirlo sin perder la barra inferior.
- [x] Detalle de evento, al que navegan Inicio y Calendario (pregunta
      resuelta nº 6). Reutiliza el layout del detalle de atractivo: el
      armazón común vive en `lib/core/widgets/detail_layout.dart`.
- [x] Mover Artesanos al quinto tab y sacar Ajustes de la barra
      (preguntas resueltas nº 8 y nº 1). La barra es ahora Inicio ·
      Explorar · Calendario · Mapa · Artesanos, y Ajustes se abre desde el
      engranaje de la cabecera de Inicio.
- [x] `settings`: feature nueva con idioma (persistido) y "acerca de".
- [ ] `artisans`: la feature en sí. **Bloqueada por contenido**, ver abajo.
- [ ] Migrar cada scaffold al patrón de `attractions`
      (ver [`project_rules/08_folder_structure.md`](../project_rules/08_folder_structure.md)).
      Queda uno: `artisans`, una página de 17 líneas sin domain ni data.

### Qué falta para cerrar la Fase 2

Las tres decisiones que bloqueaban la fase **están tomadas** (2026-09-21) y
registradas en [`CONCEPTO.md`](./CONCEPTO.md) §9:

| Pregunta | Decisión | Estado |
| --- | --- | --- |
| nº 6 — ¿cómo es el detalle de evento? | Reutiliza el layout del de atractivo | ✅ Implementado |
| nº 8 — ¿en qué tab vive Artesanos? | Ocupa el slot del tab Perfil | ✅ Implementado |
| nº 1 — ¿qué contiene Perfil? | Deja de ser tab; ajustes mínimos desde Inicio | ✅ Implementado |

**Ya no queda nada programable en la Fase 2.** El único bloqueante es la
pregunta nº 18: no hay fotos ni contactos reales de artesanos levantados en
campo. La pantalla está diseñada, el tab asignado y la arquitectura montada;
falta el contenido.

> **La Fase 2 cierra con trabajo de campo, no con más código.** `artisans`
> espera a que alguien vaya a Pujilí con una cámara y una libreta. Todo lo
> demás de la fase está hecho.

## Fase 3 — Calidad
- [ ] Árbol de tests de `attractions` (usecases, repo, bloc, widget).
      **A medias:** hay asset, modelo y página de detalle; faltan usecase,
      repositorio y bloc. La feature plantilla está hoy peor cubierta que
      `calendar`, que sí tiene el árbol completo.
- [ ] Subir cobertura a ≥ 80 % en `domain/` y `data/`.
- [ ] Endurecer lints a `--fatal-infos` por grupos
      (ver [`project_rules/09_code_style.md`](../project_rules/09_code_style.md)).

## Fase 4 — Publicación
- [x] Ambientes dev/prod con flavors (ver [`FLAVORS.md`](./FLAVORS.md)),
      en Android y en Xcode, con nombre de lanzador distinto y cinta "DEV".
- [x] Firma de release y build de AAB (ver [`RELEASE_ANDROID.md`](./RELEASE_ANDROID.md)):
      el mecanismo está (`make aab-prod`, `make verify-signing`, firma
      condicional vía `android/key.properties`). **Falta generar el keystore
      real**, que no se versiona.
- [ ] Ficha de Play Store / App Store.

## Antes de implementar

El producto está en [`CONCEPTO.md`](./CONCEPTO.md) (el qué y el porqué,
con el modelo de datos y **20 preguntas abiertas** numeradas) y el diseño
en [`MOCKS.html`](./MOCKS.html) (las 7 pantallas). Ahí está el detalle; no
se duplica aquí.

Lo que sigue es solo lo que se ve al contrastar esos documentos **con el
código de este repo**.

### Prioridad: resuelta, los dos documentos coinciden

Este roadmap arrancaba la Fase 1 por el mapa mientras `CONCEPTO.md` §8 lo
ponía cuarto, detrás del calendario, Inicio y Atractivos. **Ya no hay
contradicción:** esas tres están hechas, así que el mapa es lo siguiente en
los dos documentos. Sigue mandando `CONCEPTO.md` si vuelven a divergir.

### Nombres de campo: resuelto, el código manda

`CONCEPTO.md` §6.2 lo zanja: *"los nombres exactos deben leerse del
`attractions.json` y de la entity reales del repo, que son la fuente de
verdad. No renombrar nada para que cuadre con este documento"*.

Así que **no hay nada que cambiar en el código**. Solo hay que traducir al
leer los documentos:

| En los documentos | En el repo (`Attraction`) |
| --- | --- |
| `photos[]`, `photos[0]` | `images` |
| `locationLabel` | `location` |
| `description` | `shortDescription` |

Las 4 categorías sí coinciden: `cultural`, `religious`, `nature`, `crafts`.

### Coordenadas imprecisas: afectan a "Cómo llegar"

"Cómo llegar" ya está en producción: abre la app de mapas con las coordenadas
del JSON, así que **la ruta es tan buena como el dato**. Dos atractivos tienen
coordenadas que son minutos de arco enteros pasados a decimal, lo que da hasta
**~1,8 km de error**:

| Atractivo | Coordenadas | Equivale a |
| --- | --- | --- |
| Santuario del Niño de Isinche | `-0.9667, -78.7000` | 0°58′ S, 78°42′ O |
| Talleres de cerámica La Victoria | `-0.9333, -78.6667` | 0°56′ S, 78°40′ O |

Comprobado en el simulador: con la del santuario, Apple Maps traza la ruta
a "Pujili" genérico, no al santuario. **Levantarlas en campo** (un pin en
Google Maps sobre el sitio real basta) antes de publicar. No se corrigen a
ojo: una coordenada inventada es peor que una imprecisa.

El mismo dato alimentará los pines del mapa, así que el error se propaga a
la Fase 1.

### Datos que el modelo todavía no tiene

- **Distancia** en las tarjetas y en el sheet del mapa. No existe el campo,
  y depende de la pregunta abierta nº 9 (geolocalización).
- **Entidades nuevas**: `FestivalEvent` ya existe, creada con la feature
  `calendar`. `ThematicRoute` existe como enumerado del mapa, no como entidad
  con datos: hoy una ruta es un filtro por categoría, y si además debe ser un
  recorrido dibujado sigue siendo la pregunta abierta nº 11. Falta
  `ArtisanItem`. `AdPlacement` es V2 y no se implementa.

### Lo que hay que deshacer en el repo

El tab **Perfil** apunta hoy a `ArtisansPage` como parche del scaffold
([`main_shell.dart`](../lib/shell/main_shell.dart)). Los dos documentos lo
marcan como provisional. No construir sobre ese parche.

> Marca cada casilla en la PR que la complete y refleja el cambio en
> `CHANGELOG.md` (sección `Unreleased`).
