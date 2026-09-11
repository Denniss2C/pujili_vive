# 📘 Project Rules — Pujilí Vive

Documento maestro de reglas, convenciones y estándares arquitectónicos
del proyecto **Pujilí Vive**. Su propósito es que cualquier desarrollador
pueda incorporarse y contribuir de forma consistente, manteniendo la
calidad, escalabilidad y mantenibilidad del producto.

> **Estos documentos NO son opcionales.** Su cumplimiento es requisito
> obligatorio para que una Pull Request sea aprobada.

---

## 🎯 Objetivo

Definir un marco de trabajo estandarizado para el desarrollo en Flutter,
alineado con:

- **Clean Architecture**
- **Principios SOLID**
- **BLoC Pattern (flutter_bloc)**
- **Testabilidad y cobertura de pruebas**
- **Seguridad y manejo de claves**
- **CI/CD y calidad continua**

---

## 📂 Estructura de este directorio

| #   | Archivo                          | Tema                                     |
| --- | -------------------------------- | ---------------------------------------- |
| 01  | `01_architecture.md`             | Arquitectura general del proyecto        |
| 02  | `02_clean_architecture_rules.md` | Reglas de Clean Architecture             |
| 03  | `03_bloc_rules.md`               | Reglas de uso de BLoC                    |
| 04  | `04_repository_rules.md`         | Repositorios y datasources               |
| 05  | `05_data_sources_rules.md`       | Datos locales (JSON/assets) y Google Maps|
| 06  | `06_testing_rules.md`            | Testing (Unit, Widget, Integration)      |
| 07  | `07_naming_conventions.md`       | Convenciones de nombrado                 |
| 08  | `08_folder_structure.md`         | Estructura obligatoria de carpetas       |
| 09  | `09_code_style.md`               | Estilo de código y linters               |
| 10  | `10_security_rules.md`           | Seguridad, secretos y claves             |
| 11  | `11_performance_rules.md`        | Rendimiento y buenas prácticas           |
| 12  | `12_definition_of_done.md`       | Definition of Done (DoD) para PRs        |

---

## 🚦 Cómo usar este manual

1. **Antes de empezar** una tarea, lee el archivo del área que vas a tocar.
2. **Antes de abrir una PR**, revisa la
   [`12_definition_of_done.md`](./12_definition_of_done.md).
3. **Si encuentras una inconsistencia** entre el código y este manual, el
   manual tiene prioridad: abre un issue y propón la corrección.

---

## ⚖️ Jerarquía de decisiones

Cualquier cambio arquitectónico debe respetar, en este orden:

1. Clean Architecture
2. Principios SOLID
3. BLoC Pattern
4. Testabilidad
5. Escalabilidad

> La feature **`attractions`** es la **plantilla de referencia**: cumple
> la estructura entera (domain / data / presentation + BLoC + tests) y es
> contra la que se compara cualquier feature nueva.
