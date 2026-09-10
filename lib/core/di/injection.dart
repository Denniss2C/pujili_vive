import 'package:get_it/get_it.dart';
import '../../features/attractions/data/datasources/attractions_local_datasource.dart';
import '../../features/attractions/data/repositories/attractions_repository_impl.dart';
import '../../features/attractions/domain/repositories/attractions_repository.dart';
import '../../features/attractions/domain/usecases/get_attractions.dart';
import '../../features/attractions/presentation/bloc/attractions_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Bloc
  sl.registerFactory(() => AttractionsBloc(getAttractions: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAttractions(sl()));

  // Repository
  sl.registerLazySingleton<AttractionsRepository>(
    () => AttractionsRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AttractionsLocalDataSource>(
    () => AttractionsLocalDataSourceImpl(),
  );
}
