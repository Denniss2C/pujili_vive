import 'package:flutter_bloc/flutter_bloc.dart';

/// Los cinco tabs de la barra inferior, en su orden real.
///
/// El quinto era `profile`. Perfil se quedo sin contenido al no haber
/// cuentas de usuario, asi que el slot pasa a Artesanos y los ajustes se
/// abren desde la cabecera de Inicio (`docs/CONCEPTO.md` §4.6 y §4.7,
/// preguntas resueltas 1 y 8).
enum ShellTab { home, explore, calendar, map, artisans }

/// Cual de los cinco tabs esta activo.
///
/// Vive en un cubit y no en un `setState` del shell porque **deja de ser
/// estado local** en cuanto otra pantalla necesita cambiarlo. Hoy solo lo
/// mueve la barra: Inicio dejo de mandar al Calendario cuando su tarjeta
/// paso a abrir el detalle de la fiesta dentro del propio tab. Se queda
/// como cubit porque la franja "Ver fiestas" de Artesanos volvera a
/// necesitarlo (`docs/CONCEPTO.md` §4.6), y porque las reglas del
/// proyecto listan "setState para estado compartido" como anti-patron
/// (project_rules/03_bloc_rules.md §5).
class ShellCubit extends Cubit<ShellTab> {
  ShellCubit() : super(ShellTab.home);

  void select(ShellTab tab) => emit(tab);
}
