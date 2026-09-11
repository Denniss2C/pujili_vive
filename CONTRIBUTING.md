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
3. Asegúrate de que pasa el CI local. Estos son exactamente los mismos
   comandos que ejecuta el workflow:
   ```bash
   dart format --output=none --set-exit-if-changed lib test
   flutter analyze --no-fatal-infos
   flutter test --coverage
   ```
   > Ojo con `flutter analyze`: trae `--fatal-infos` activado por
   > defecto. El CI lo desactiva a propósito (ver §4), así que usa el
   > mismo flag en local o verás fallos que el CI no da.
4. Abre una Pull Request contra `main` usando la plantilla.
5. Espera a que **los dos jobs del CI** estén verdes: `Formato, análisis
   y tests` y `Build Android (debug)`. Hasta entonces GitHub bloquea el
   botón de merge.

> `main` está protegida por una regla de GitHub, no solo por convención:
>
> - No se admite push directo: todo entra por Pull Request.
> - No se puede mergear con el CI en rojo.
> - No se admite force-push ni borrar la rama.
> - La regla aplica también al owner del repositorio.
>
> No se exigen aprobaciones porque hoy el proyecto tiene un único
> colaborador y GitHub no permite aprobar las PRs propias. Cuando se
> sume una segunda persona, conviene subir la revisión obligatoria a 1.

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
