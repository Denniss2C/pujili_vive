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

> Marca cada casilla en la PR que la complete y refleja el cambio en
> `CHANGELOG.md` (sección `Unreleased`).
