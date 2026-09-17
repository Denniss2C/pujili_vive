import 'package:get_it/get_it.dart';
import '../../features/attractions/data/datasources/attractions_local_datasource.dart';
import '../../features/attractions/data/repositories/attractions_repository_impl.dart';
import '../../features/attractions/domain/repositories/attractions_repository.dart';
import '../../features/attractions/domain/usecases/get_attractions.dart';
import '../../features/attractions/presentation/bloc/attractions_bloc.dart';
import '../../features/calendar/data/datasources/calendar_local_datasource.dart';
import '../../features/calendar/data/repositories/calendar_repository_impl.dart';
import '../../features/calendar/domain/repositories/calendar_repository.dart';
import '../../features/calendar/domain/usecases/get_festival_events.dart';
import '../../features/calendar/presentation/bloc/calendar_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../shell/shell_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Bloc
  sl.registerFactory(() => AttractionsBloc(getAttractions: sl()));
  sl.registerFactory(() => CalendarBloc(getFestivalEvents: sl()));
  sl.registerFactory(
    () => HomeBloc(getFestivalEvents: sl(), getAttractions: sl()),
  );

  // El tab activo del shell vive toda la sesion, no por pantalla.
  sl.registerLazySingleton(ShellCubit.new);

  // Use cases
  sl.registerLazySingleton(() => GetAttractions(sl()));
  sl.registerLazySingleton(() => GetFestivalEvents(sl()));

  // Repository
  sl.registerLazySingleton<AttractionsRepository>(
    () => AttractionsRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AttractionsLocalDataSource>(
    () => AttractionsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CalendarLocalDataSource>(
    () => CalendarLocalDataSourceImpl(),
  );
}
