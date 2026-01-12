// lib/injection/injection_vark.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../features/question/data/datasource/vark_remote_datasource.dart';
import '../features/question/data/datasource/vark_local_datasource.dart';
import '../features/question/data/repositories/vark_repository_impl.dart';
import '../features/question/domain/repositories/vark_repository.dart';
import '../features/question/domain/usecases/get_ml_prediction.dart';
import '../features/question/domain/usecases/get_vark_questions.dart';
import '../features/question/domain/usecases/calculate_vark_scores.dart';
import '../features/question/presentation/bloc/vark_bloc.dart';

final sl = GetIt.instance;

Future<void> initVark() async {
  sl.registerFactory(
    () => VarkBloc(
      getMLPrediction: sl(),
      getVarkQuestions: sl(),
      calculateVarkScores: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetMLPrediction(sl()));
  sl.registerLazySingleton(() => GetVarkQuestions(sl()));
  sl.registerLazySingleton(() => CalculateVarkScores(sl()));

  sl.registerLazySingleton<VarkRepository>(
    () => VarkRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<VarkRemoteDataSource>(
    () => VarkRemoteDataSourceImpl(
      dio: sl(),
      baseUrl: const String.fromEnvironment(
        'ML_API_URL',
        defaultValue:
            'http://192.168.1.100:8000', // ⚠️ GANTI dengan IP server Anda
      ),
    ),
  );

  sl.registerLazySingleton<VarkLocalDataSource>(
    () => VarkLocalDataSourceImpl(),
  );

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() => Dio());
  }
}
