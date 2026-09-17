# Roadmap — Pujilí Vive

> Qué estamos haciendo y qué sigue. El **cómo** está en
> [`project_rules/`](../project_rules/); el **estado** en
> [`ARQUITECTURA.md`](./ARQUITECTURA.md).

## Fase 0 — MVP (hecho)
- [x] Clean Architecture + BLoC con `attractions` como plantilla.
- [x] Shell con navegación inferior unificada (5 tabs).
- [x] i18n ES/EN desde los `.arb`.
- [x] 6 atractivos en `assets/data/attractions.json`.
- [x] Higiene de repo: políticas, CI, project_rules.

## Fase 1 — Contenido y mapa
- [ ] Cargar la Google Maps API key (ver [`MAPS_SETUP.md`](./MAPS_SETUP.md)).
- [ ] Reemplazar el placeholder de `map_page.dart` por `GoogleMap` con pines
      de los atractivos.
- [x] Fotos reales de Pujilí en `assets/images/` (comprimidas).
- [ ] Datos prácticos verificados (horarios, cómo llegar, contactos).

## Fase 2 — Features scaffold → completas
- [x] `calendar`: fiestas y eventos (diferenciador clave). Falta el
      detalle de evento, que no esta diseñado (pregunta abierta nº 6).
- [ ] `artisans`: feature propia (hoy comparte pantalla con "Perfil").
- [x] `home`: contenido de bienvenida real. Sin buscador (pregunta
      abierta nº 3) ni carrusel artesanal (bloqueado por contenido).
- [ ] Migrar cada scaffold al patrón de `attractions`
      (ver [`project_rules/08_folder_structure.md`](../project_rules/08_folder_structure.md)).

## Fase 3 — Calidad
- [ ] Árbol de tests de `attractions` (usecases, repo, bloc, widget).
- [ ] Subir cobertura a ≥ 80 % en `domain/` y `data/`.
- [ ] Endurecer lints a `--fatal-infos` por grupos
      (ver [`project_rules/09_code_style.md`](../project_rules/09_code_style.md)).

## Fase 4 — Publicación
- [ ] Ambientes dev/prod con flavors (ver [`FLAVORS.md`](./FLAVORS.md)).
- [ ] Firma de release y build de AAB (ver [`RELEASE_ANDROID.md`](./RELEASE_ANDROID.md)).
- [ ] Ficha de Play Store / App Store.

## Antes de implementar

El producto está en [`CONCEPTO.md`](./CONCEPTO.md) (el qué y el porqué,
con el modelo de datos y **20 preguntas abiertas** numeradas) y el diseño
en [`MOCKS.html`](./MOCKS.html) (las 7 pantallas). Ahí está el detalle; no
se duplica aquí.

Lo que sigue es solo lo que se ve al contrastar esos documentos **con el
código de este repo**.

### ⚠️ Contradicción de prioridad: este documento vs. CONCEPTO

`CONCEPTO.md` §8 marca como `[DECIDIDO]` que el **calendario de fiestas es
el diferenciador** y la prioridad 1, y que *"si hay que recortar, se
recorta de abajo hacia arriba, nunca el calendario"*. Su orden es:

1. `calendar` · 2. `home` con countdown · 3. `attractions` (hecha) ·
4. `map` · 5. `artisans` · 6. `profile` · 7. ads (V2)

Pero la **Fase 1** de este roadmap arranca por el mapa, que allí es el
cuarto. **Hay que alinear los dos documentos**: o se reordenan las fases,
o se corrige el concepto. Mientras no se resuelva, manda `CONCEPTO.md`,
que es donde la decisión está marcada como tomada.

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

"Cómo llegar" abre la app de mapas con las coordenadas del JSON, así que
**la ruta es tan buena como el dato**. Dos atractivos tienen coordenadas
que son minutos de arco enteros pasados a decimal, lo que da hasta
**~1,8 km de error**:

| Atractivo | Coordenadas | Equivale a |
| --- | --- | --- |
| Santuario del Niño de Isinche | `-0.9667, -78.7000` | 0°58′ S, 78°42′ O |
| Talleres de cerámica La Victoria | `-0.9333, -78.6667` | 0°56′ S, 78°40′ O |

Comprobado en el simulador: con la del santuario, Apple Maps traza la ruta
a "Pujili" genérico, no al santuario. **Levantarlas en campo** (un pin en
Google Maps sobre el sitio real basta) antes de publicar. No se corrigen a
ojo: una coordenada inventada es peor que una imprecisa.

### Datos que el modelo todavía no tiene

- **Distancia** en las tarjetas y en el sheet del mapa. No existe el campo,
  y depende de la pregunta abierta nº 9 (geolocalización).
- **Entidades nuevas**: `FestivalEvent`, `ArtisanItem` y `ThematicRoute`.
  Ninguna existe. `AdPlacement` es V2 y no se implementa.

### Lo que hay que deshacer en el repo

El tab **Perfil** apunta hoy a `ArtisansPage` como parche del scaffold
([`main_shell.dart`](../lib/shell/main_shell.dart)). Los dos documentos lo
marcan como provisional. No construir sobre ese parche.

> Marca cada casilla en la PR que la complete y refleja el cambio en
> `CHANGELOG.md` (sección `Unreleased`).
