# 12 — Definition of Done (DoD)

> Una tarea NO está terminada hasta cumplir **todos** los puntos. La PR no
> se mergea si falta cualquiera.

---

## ✅ Código
- [ ] Implementado en la **feature** correcta (`features/<feature>/{data,domain,presentation}`).
- [ ] Si la feature no existía, se creó siguiendo [`08_folder_structure.md`](./08_folder_structure.md).
- [ ] Sin `setState` para estado de feature (usar BLoC).
- [ ] Strings en `lib/l10n/app_*.arb` (ES y EN), nada hardcodeado.
- [ ] Sin `print`, sin TODOs sin ticket, sin código comentado.
- [ ] `dart format` sin diffs.
- [ ] `flutter analyze` sin errores ni warnings nuevos.

## ✅ Arquitectura
- [ ] Entidad(es) inmutables (`Equatable`) en `domain/entities/`.
- [ ] `usecase(s)` en `domain/usecases/`, uno por acción.
- [ ] Repositorio `abstract` en `domain/` + impl en `data/`.
- [ ] Datasource(s) en `data/datasources/`.
- [ ] Model(s) con `fromJson`/`toEntity`.
- [ ] BLoC: `*_bloc/_event/_state`, `Event`/`State` sellados y `Equatable`.
- [ ] BLoC depende solo de UseCases.
- [ ] Estados: `initial`, `loading`, `loaded`, `error`.

## ✅ Seguridad
- [ ] Sin secretos ni Maps API key en el código.
- [ ] Sin permisos nuevos sin documentar.
- [ ] Validación de inputs.

## ✅ Testing
- [ ] Tests de los nuevos `usecase(s)`.
- [ ] Test de repositorio/datasource con mocks.
- [ ] `blocTest` por cada evento nuevo.
- [ ] Widget test de la(s) pantalla(s) modificada(s).
- [ ] Cobertura ≥ 80 % en `domain/` y `data/` de la feature.

## ✅ UI/UX
- [ ] Responsive (probar en 360dp, 411dp, 600dp).
- [ ] Estados de carga, error y vacío diseñados y localizados.
- [ ] Accesibilidad: `Semantics` en interactivos, contraste WCAG AA.
- [ ] Bilingüe ES/EN verificado.

## ✅ Documentación
- [ ] `///` en clases/métodos públicos.
- [ ] Reglas nuevas → actualizar `project_rules/`.
- [ ] `CHANGELOG.md` actualizado en `Unreleased`.

## ✅ CI/CD
- [ ] Pipeline en verde: `dart format --set-exit-if-changed`,
      `flutter analyze`, `flutter test --coverage`, build de Android.
- [ ] Si hay dependencia nueva, `pubspec.yaml` revisado y `pubspec.lock` commiteado.

## ✅ Revisión
- [ ] PR con descripción clara (qué, por qué, cómo probar).
- [ ] Capturas/video si hay cambio visual.
- [ ] Al menos 1 review aprobado.
- [ ] Sin comentarios sin resolver.
- [ ] Rama actualizada con `main`.

---

## 🚦 Estados de un ticket
```
📋 Backlog → 🟡 In Progress → 👀 In Review → ✅ Done
                                      │
                                      └─ (rechazado) → 🟡 In Progress
```
