import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutest/data/repositories/firebase_auth_repository.dart';
import 'package:edutest/data/repositories/firestore_profile_repository.dart';
import 'package:edutest/data/repositories/firestore_vark_result_repository.dart';
import 'package:edutest/domain/repositories/auth_repository.dart';
import 'package:edutest/domain/repositories/profile_repository.dart';
import 'package:edutest/domain/repositories/vark_result_repository.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/features/discuss/data/datasources/discussion_remote_datasource.dart';
import 'package:edutest/features/discuss/data/repositories/discussion_repository_impl.dart';
import 'package:edutest/features/discuss/domain/repositories/discussion_repository.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_detail_bloc.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_list_bloc.dart';
import 'package:edutest/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'injection_vark.dart' as vark_injection;

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerFactory<AuthRepository>(
    () => FirebaseAuthRepository(),
  );

  sl.registerFactory<ProfileRepository>(
    () => FirestoreProfileRepository(),
  );

  sl.registerLazySingleton<VarkResultRepository>(
    () => FirestoreVarkResultRepository(),
  );

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  sl.registerLazySingleton<DiscussionRemoteDatasource>(
    () => DiscussionRemoteDatasource(firestore: sl()),
  );

  sl.registerLazySingleton<DiscussionRepository>(
    () => DiscussionRepositoryImpl(
      remoteDatasource: sl(),
      uuid: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl<AuthRepository>(),
      profileRepository: sl<ProfileRepository>(),
    ),
  );

  sl.registerFactory(
    () => ProfileCubit(profileRepository: sl<ProfileRepository>()),
  );

  sl.registerFactory(
    () => DiscussionListBloc(repository: sl()),
  );

  sl.registerFactory(
    () => DiscussionDetailBloc(repository: sl()),
  );

  await vark_injection.initVark();
}
