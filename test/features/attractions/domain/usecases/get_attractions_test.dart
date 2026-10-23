import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/core/usecases/usecase.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction.dart';
import 'package:pujili_vive/features/attractions/domain/entities/attraction_category.dart';
import 'package:pujili_vive/features/attractions/domain/repositories/attractions_repository.dart';
import 'package:pujili_vive/features/attractions/domain/usecases/get_attractions.dart';

import '../../../../helpers/fixtures/attraction_fixtures.dart';

class _MockAttractionsRepository extends Mock
    implements AttractionsRepository {}

void main() {
  late _MockAttractionsRepository repository;
  late GetAttractions usecase;

  setUp(() {
    repository = _MockAttractionsRepository();
    usecase = GetAttractions(repository);
  });

  test('devuelve los atractivos en el orden del repositorio', () async {
    // A diferencia de las fiestas, aqui el orden del JSON es el orden
    // editorial de la pantalla: el usecase no debe reordenar.
    final attractions = [
      buildAttraction(id: 'quilotoa', category: AttractionCategory.nature),
      buildAttraction(id: 'santuario-nino-isinche'),
    ];
    when(() => repository.getAttractions())
        .thenAnswer((_) async => Right(attractions));

    final result = await usecase(NoParams());

    expect(
      result.getOrElse(() => <Attraction>[]).map((a) => a.id).toList(),
      ['quilotoa', 'santuario-nino-isinche'],
    );
    verify(() => repository.getAttractions()).called(1);
  });

  test('propaga el fallo cuando el repositorio falla', () async {
    when(() => repository.getAttractions())
        .thenAnswer((_) async => const Left(CacheFailure('sin datos')));

    final result = await usecase(NoParams());

    expect(
      result,
      const Left<Failure, List<Attraction>>(CacheFailure('sin datos')),
    );
  });
}
