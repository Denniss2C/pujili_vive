# 11 — Reglas de Rendimiento

> La app debe ser fluida en dispositivos de gama media.

---

## 1. Rebuilds

- `const` widgets siempre que se pueda.
- `BlocBuilder` envuelve **solo** la sección que depende del estado, no el
  `Scaffold` entero.
- `BlocSelector` cuando solo se necesita una parte del estado.

```dart
BlocSelector<AttractionsBloc, AttractionsState, int>(
  selector: (s) => s.attractions.length,
  builder: (_, count) => Text('$count'),
);
```

---

## 2. Listas

- `ListView.builder` con `itemCount`/`itemBuilder`.
- `itemExtent`/`prototypeItem` si los items son uniformes.
- ❌ Nunca `ListView(children: [...100 widgets])`.

---

## 3. Imágenes

- `Image.asset` con `cacheWidth`/`cacheHeight`.
- Placeholders para evitar layout shift.
- Comprimir las fotos reales de Pujilí antes de meterlas a `assets/images/`.

---

## 4. Mapa

- Limitar el número de `Marker` visibles; agrupar si crecen.
- No recrear el `MapController` en cada rebuild, y **liberarlo** en
  `dispose`: `FlutterMap` solo libera el que crea él mismo, y al nuestro le
  cuelga un `AnimationController`.
- No reencuadrar la cámara en cada repintado. El filtro de ruta devuelve
  una lista nueva cada build, así que el disparador es el **cambio de
  ruta**, no la lista.
- Poner suelo de zoom (`minZoom`): alejarse hasta ver el mundo entero pide
  teselas de medio planeta a un servidor donado.
- Cargar el mapa de forma perezosa (solo al entrar al tab). **Pendiente:**
  hoy el `IndexedStack` del shell monta los cinco tabs al arrancar, así que
  el mapa pide teselas aunque nadie abra su tab.

---

## 5. Streams y controladores

- `AnimationController`/`StreamSubscription`/`TextEditingController`:
  crear en `initState`, `dispose` en `dispose`.
- `Bloc.close()` lo maneja `BlocProvider`.

---

## 6. Build y release

- `--release` con `--obfuscate --split-debug-info=build/symbols`.
- `--tree-shake-icons` activado.
- Vigilar el tamaño del APK.

---

## 7. Errores prohibidos

- ❌ Cálculos costosos en `build()` (mover a BLoC/UseCase).
- ❌ Imágenes sin `cacheWidth`/`cacheHeight`.
- ❌ Streams sin cancelar.
- ❌ `SingleChildScrollView` + `Column` con cientos de items.

---

## 8. Checklist

- [ ] `const` donde aplique.
- [ ] `BlocSelector`/`BlocBuilder` segmentado.
- [ ] Imágenes con cache dimensionado.
- [ ] Streams/controladores liberados en `dispose`.
- [ ] Markers del mapa acotados.
