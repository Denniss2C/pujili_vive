import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pujili_vive/shell/shell_cubit.dart';

void main() {
  test('arranca en Inicio', () {
    expect(ShellCubit().state, ShellTab.home);
  });

  blocTest<ShellCubit, ShellTab>(
    'cambia de tab',
    build: ShellCubit.new,
    act: (cubit) => cubit
      ..select(ShellTab.calendar)
      ..select(ShellTab.explore),
    expect: () => [ShellTab.calendar, ShellTab.explore],
  );

  test('el orden de los tabs es el de la barra, y no puede cambiar', () {
    // El indice del enum ES el indice del BottomNavigationBar y del
    // IndexedStack. Reordenar este enum cambiaria de pantalla en silencio.
    expect(ShellTab.values, [
      ShellTab.home,
      ShellTab.explore,
      ShellTab.calendar,
      ShellTab.map,
      ShellTab.artisans,
    ]);
    expect(ShellTab.calendar.index, 2);
  });
}
