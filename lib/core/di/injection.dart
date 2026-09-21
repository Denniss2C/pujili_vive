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
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_language_code.dart';
import '../../features/settings/domain/usecases/save_language_code.dart';
import '../../features/settings/presentation/cubit/locale_cubit.dart';
import '../../shell/shell_cubit.dart';
import '../services/maps_launcher.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Bloc
  sl.registerFactory(() => AttractionsBloc(getAttractions: sl()));
  sl.registerFactory(() => CalendarBloc(getFestivalEvents: sl()));
  sl.registerFactory(
    () => HomeBloc(getFestivalEvents: sl(), getAttractions: sl()),
  );

  // Factory y no singleton: lo provee un BlocProvider(create:), que CIERRA
  // el cubit al desmontarse. Con un singleton, un segundo montaje de la
  // app recibiria un cubit ya cerrado. Sigue durando toda la sesion porque
  // el provider vive en la raiz.
  sl.registerFactory(ShellCubit.new);

  // Mismo motivo que ShellCubit: lo cierra el BlocProvider de la raiz.
  sl.registerFactory(
    () => LocaleCubit(getLanguageCode: sl(), saveLanguageCode: sl()),
  );

  // Servicios de plataforma.
  sl.registerLazySingleton<MapsLauncher>(UrlMapsLauncher.new);

  // Use cases
  sl.registerLazySingleton(() => GetAttractions(sl()));
  sl.registerLazySingleton(() => GetFestivalEvents(sl()));
  sl.registerLazySingleton(() => GetLanguageCode(sl()));
  sl.registerLazySingleton(() => SaveLanguageCode(sl()));

  // Repository
  sl.registerLazySingleton<AttractionsRepository>(
    () => AttractionsRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AttractionsLocalDataSource>(
    () => AttractionsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CalendarLocalDataSource>(
    () => CalendarLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(),
  );
}
