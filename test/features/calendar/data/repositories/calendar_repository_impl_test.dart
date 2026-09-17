import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pujili_vive/core/constants/localized_text.dart';
import 'package:pujili_vive/core/error/exceptions.dart';
import 'package:pujili_vive/core/error/failures.dart';
import 'package:pujili_vive/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:pujili_vive/features/calendar/data/models/festival_event_model.dart';
import 'package:pujili_vive/features/calendar/data/repositories/calendar_repository_impl.dart';

class _MockLocalDataSource extends Mock implements CalendarLocalDataSource {}

void main() {
  late _MockLocalDataSource dataSource;
  late CalendarRepositoryImpl repository;

  final model = FestivalEventModel(
    id: 'corpus-christi-danzantes',
    title: const LocalizedText(es: 'Corpus Christi', en: 'Corpus Christi'),
    shortDescription: const LocalizedText(es: 'La fiesta', en: 'The festival'),
    startDate: DateTime(2027, 5, 27),
    isHighlighted: true,
    images: const [],
  );

  setUp(() {
    dataSource = _MockLocalDataSource();
    repository = CalendarRepositoryImpl(localDataSource: dataSource);
  });

  test('devuelve las fiestas cuando el datasource responde', () async {
    when(() => dataSource.getFestivalEvents()).thenAnswer((_) async => [model]);

    final result = await repository.getFestivalEvents();

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => []), [model]);
  });

  test('convierte CacheException en CacheFailure', () async {
    when(() => dataSource.getFestivalEvents())
        .thenThrow(CacheException('asset ausente'));

    final result = await repository.getFestivalEvents();

    expect(
      result.fold((f) => f, (_) => null),
      isA<CacheFailure>().having((f) => f.message, 'message', 'asset ausente'),
    );
  });

  test('cualquier otro error acaba en DataFailure', () async {
    // Un JSON con un campo mal tipado revienta en el fromJson, no en el
    // datasource, asi que el repositorio tiene que atraparlo igual.
    when(() => dataSource.getFestivalEvents())
        .thenThrow(const FormatException('fecha invalida'));

    final result = await repository.getFestivalEvents();

    expect(result.fold((f) => f, (_) => null), isA<DataFailure>());
  });
}
