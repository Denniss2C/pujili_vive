import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/constants/localized_text.dart';
import 'package:pujili_vive/core/error/exceptions.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/features/attractions/data/datasources/attractions_local_datasource.dart';
import 'package:pujili_vive/features/attractions/data/models/attraction_model.dart';
import 'package:pujili_vive/features/attractions/data/repositories/attractions_repository_impl.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';

class _MockLocalDataSource extends Mock implements AttractionsLocalDataSource {}

void main() {
  late _MockLocalDataSource dataSource;
  late AttractionsRepositoryImpl repository;

  const model = AttractionModel(
    id: 'quilotoa',
    name: LocalizedText(es: 'Laguna del Quilotoa', en: 'Quilotoa Lagoon'),
    shortDescription: LocalizedText(es: 'Un cráter', en: 'A crater'),
    category: AttractionCategory.nature,
    latitude: -0.8583,
    longitude: -78.9019,
    location: LocalizedText(es: 'Zumbahua', en: 'Zumbahua'),
    images: [],
  );

  setUp(() {
    dataSource = _MockLocalDataSource();
    repository = AttractionsRepositoryImpl(localDataSource: dataSource);
  });

  test('devuelve los atractivos cuando el datasource responde', () async {
    when(() => dataSource.getAttractions()).thenAnswer((_) async => [model]);

    final result = await repository.getAttractions();

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => []), [model]);
  });

  test('convierte CacheException en CacheFailure', () async {
    when(() => dataSource.getAttractions())
        .thenThrow(CacheException('asset ausente'));

    final result = await repository.getAttractions();

    expect(
      result.fold((f) => f, (_) => null),
      isA<CacheFailure>().having((f) => f.message, 'message', 'asset ausente'),
    );
  });

  test('cualquier otro error acaba en DataFailure', () async {
    // El datasource envuelve todo en CacheException, pero el repositorio
    // no debe depender de eso: si algo se escapa, sigue siendo un Left.
    when(() => dataSource.getAttractions())
        .thenThrow(const FormatException('coordenada invalida'));

    final result = await repository.getAttractions();

    expect(result.fold((f) => f, (_) => null), isA<DataFailure>());
  });
}
