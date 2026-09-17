import 'package:flutter_bloc/flutter_bloc.dart';

/// Los cinco tabs de la barra inferior, en su orden real.
enum ShellTab { home, explore, calendar, map, profile }

/// Cual de los cinco tabs esta activo.
///
/// Vive en un cubit y no en un `setState` del shell porque **deja de ser
/// estado local** en cuanto otra pantalla necesita cambiarlo: Inicio manda
/// al Calendario y a Explorar, y mañana Artesanos hara lo mismo. Las
/// reglas del proyecto listan "setState para estado compartido" como
/// anti-patron (project_rules/03_bloc_rules.md §5).
class ShellCubit extends Cubit<ShellTab> {
  ShellCubit() : super(ShellTab.home);

  void select(ShellTab tab) => emit(tab);
}
