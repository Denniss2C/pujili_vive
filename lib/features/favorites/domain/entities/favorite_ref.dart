import 'package:equatable/equatable.dart';

/// Que tipo de cosa se guardo.
///
/// Guardados mezcla atractivos y fiestas, asi que un id suelto no basta:
/// nada impide que un atractivo y una fiesta compartan id.
enum FavoriteKind { attraction, festival }

/// Referencia a algo guardado.
///
/// Se persiste como una sola cadena `tipo:id` en vez de dos listas
/// separadas: asi añadir un tercer tipo mañana no cambia el formato de
/// almacenamiento ni obliga a migrar lo que el usuario ya tiene guardado.
class FavoriteRef extends Equatable {
  final FavoriteKind kind;
  final String id;

  const FavoriteRef({required this.kind, required this.id});

  const FavoriteRef.attraction(this.id) : kind = FavoriteKind.attraction;

  const FavoriteRef.festival(this.id) : kind = FavoriteKind.festival;

  String get key => '${kind.name}:$id';

  /// Devuelve `null` si la cadena no tiene la forma esperada.
  ///
  /// Pasa cuando una version vieja guardo otro formato, o cuando se
  /// retira un tipo. Se ignora la entrada en vez de reventar: perder un
  /// guardado es molesto, que no abra la pantalla es peor.
  static FavoriteRef? tryParse(String value) {
    final sep = value.indexOf(':');
    if (sep <= 0 || sep == value.length - 1) return null;

    final name = value.substring(0, sep);
    final kind = FavoriteKind.values.where((k) => k.name == name);
    if (kind.isEmpty) return null;

    return FavoriteRef(kind: kind.first, id: value.substring(sep + 1));
  }

  @override
  List<Object?> get props => [kind, id];
}
