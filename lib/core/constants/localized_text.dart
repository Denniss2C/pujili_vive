import 'package:equatable/equatable.dart';

/// Un texto que existe en español e inglés.
/// Se resuelve al idioma activo con [resolve].
class LocalizedText extends Equatable {
  final String es;
  final String en;

  const LocalizedText({required this.es, required this.en});

  String resolve(String languageCode) {
    return languageCode == 'en' ? en : es;
  }

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      es: json['es'] as String? ?? '',
      en: json['en'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [es, en];
}
