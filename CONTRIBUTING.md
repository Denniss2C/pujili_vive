# Guía de contribución — Pujilí Vive

Gracias por contribuir. Este proyecto sigue **Clean Architecture + BLoC**
y un conjunto de reglas obligatorias documentadas en
[`project_rules/`](./project_rules/). Léelas antes de tu primera PR.

> El cumplimiento de `project_rules/` y de la
> [Definition of Done](./project_rules/12_definition_of_done.md) es
> **requisito** para aprobar cualquier Pull Request.

---

## 1. Flujo de trabajo

1. Crea una rama desde `main` con el prefijo correcto (ver §2).
2. Haz commits pequeños y con formato convencional (ver §3).
3. Asegúrate de que pasa el CI local:
   ```bash
   dart format lib test
   flutter analyze
   flutter test
   ```
4. Abre una Pull Request contra `main` usando la plantilla.
5. Espera al menos **1 aprobación** y a que el CI esté verde.

> `main` está protegida: no se hace push directo. Todo entra por PR.

---

## 2. Convención de ramas

Formato: `<tipo>/<descripcion-corta-en-kebab>`

| Prefijo     | Uso                                             |
| ----------- | ----------------------------------------------- |
| `feat/`     | Nueva funcionalidad                             |
| `fix/`      | Corrección de bug                               |
| `chore/`    | Tareas de mantenimiento / config / tooling      |
| `docs/`     | Documentación                                   |
| `refactor/` | Refactor sin cambio de comportamiento           |
| `test/`     | Añadir o corregir tests                          |
| `perf/`     | Mejoras de rendimiento                          |

Ejemplos: `feat/mapa-con-pines`, `fix/calendario-fecha-invalida`.

---

## 3. Convención de commits (Conventional Commits)

Formato: `<tipo>(<alcance opcional>): <descripción en imperativo>`

```
feat(map): agrega pines de atractivos al GoogleMap
fix(attractions): corrige carga del JSON local en release
docs(readme): documenta la Google Maps API key
chore(ci): agrega workflow de análisis y tests
refactor(home): extrae widgets del scaffold
test(attractions): cubre GetAttractions con casos de error
```

Tipos válidos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`,
`test`, `build`, `ci`, `chore`, `revert`.

Reglas:
- Descripción en minúscula, imperativo, sin punto final.
- Un commit = un cambio lógico.
- Si cierra un issue: añade `Closes #<n>` en el cuerpo.

---

## 4. Estándar de código

- `dart format` sin diffs (línea máx. 80).
- `flutter analyze` sin errores ni warnings nuevos.
- Sin `print`, sin código comentado, sin TODOs sin ticket.
- Todo texto visible pasa por `AppLocalizations` (ES + EN).
- La feature `attractions` es la **plantilla de referencia**.

Detalle completo en [`project_rules/09_code_style.md`](./project_rules/09_code_style.md).

---

## 5. Tests

- Tests unitarios de UseCases y Repositories.
- `blocTest` por cada evento de un BLoC.
- Widget test de las pantallas modificadas.
- Cobertura objetivo ≥ 80 % en `domain/` y `data/`.

---

## 6. Reportar bugs y proponer features

Usa las plantillas de issues en GitHub (bug / feature). Para reportar
una **vulnerabilidad de seguridad**, NO abras un issue público: sigue
[`SECURITY.md`](./SECURITY.md).
