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
- [ ] Fotos reales de Pujilí en `assets/images/` (comprimidas).
- [ ] Datos prácticos verificados (horarios, cómo llegar, contactos).

## Fase 2 — Features scaffold → completas
- [x] `calendar`: fiestas y eventos (diferenciador clave). Falta el
      detalle de evento, que no esta diseñado (pregunta abierta nº 6).
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

## Antes de implementar los mocks

Los mockups están en [`MOCKS.html`](./MOCKS.html). Al contrastarlos con el
código aparecieron desajustes concretos. Resolverlos **antes** de empezar
una pantalla, no durante.

### Nombres de campo

Los mocks usan nombres que no son los del modelo real. No son errores del
diseño, pero hay que traducirlos al implementar (o renombrar la entidad):

| En los mocks | En `Attraction` |
| --- | --- |
| `photos[]`, `photos[0]` | `images` |
| `locationLabel` | `location` |
| `description` | `shortDescription` |

Las 4 categorías **sí** coinciden: `cultural`, `religious`, `nature`,
`crafts`.

### Conflicto real: `schedule` y `cost`

El detalle de atractivo dice: *"son opcionales: un mirador no tiene
horario. Si falta el dato, la columna se oculta"*. Pero hoy ambos son
**obligatorios y no nulos** en la entidad y en el JSON. Ese comportamiento
no se puede implementar sin hacerlos anulables. Decidir si se cambia el
modelo o se descarta la regla.

### Datos que el modelo no tiene

- **Distancia** en las tarjetas y en el bottom sheet del mapa. No existe
  el campo, y depende de la pregunta abierta sobre geolocalización: valor
  fijo en el JSON o cálculo contra la ubicación real.
- **Entidades nuevas**: `FestivalEvent` (calendario), `ArtisanItem`
  (artesanos) y `ThematicRoute` (rutas del mapa). Ninguna existe.

### Decisiones que bloquean implementación

1. **Dónde vive «Artesanos y comida».** Hay pantalla diseñada y feature
   `artisans` en el repo, pero ninguno de los 5 tabs le corresponde.
2. **Qué contiene el tab Perfil.** Sin decidir. Hoy apunta a
   `ArtisansPage` como parche del scaffold
   ([`main_shell.dart`](../lib/shell/main_shell.dart)); hay que deshacerlo.
3. **La fecha del Corpus Christi** es móvil (depende de la Pascua). No
   sirve fijar un día en el JSON: decidir si se calcula o se edita cada año.
4. **Qué hace «Cómo llegar»**: abrir el tab Mapa centrado, o lanzar la app
   de mapas del teléfono.

> Marca cada casilla en la PR que la complete y refleja el cambio en
> `CHANGELOG.md` (sección `Unreleased`).
