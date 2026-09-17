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
- [ ] `calendar`: fiestas y eventos (diferenciador clave).
- [ ] `artisans`: feature propia (hoy comparte pantalla con "Perfil").
- [ ] `home`: contenido de bienvenida real.
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

### Lo único que sí exige tocar el modelo: `schedule` y `cost`

Ambos documentos asumen que son **opcionales** (*"un mirador no tiene
horario; si falta el dato, la columna se oculta"*), y `CONCEPTO.md` §6.2
los lista como `String?`. Pero hoy en el repo son **obligatorios y no
nulos**, tanto en la entity como en el JSON.

Ese comportamiento no se puede implementar sin hacerlos anulables. Está
marcado `[PROPUESTA]`, así que decidir antes de tocar el detalle.

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
