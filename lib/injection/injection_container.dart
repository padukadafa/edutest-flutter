import 'package:edutest/data/repositories/firebase_auth_repository.dart';
import 'package:edutest/data/repositories/firestore_profile_repository.dart';
import 'package:edutest/data/repositories/firestore_vark_result_repository.dart';
import 'package:edutest/domain/repositories/auth_repository.dart';
import 'package:edutest/domain/repositories/profile_repository.dart';
import 'package:edutest/domain/repositories/vark_result_repository.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:get_it/get_it.dart';
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

  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl<AuthRepository>(),
      profileRepository: sl<ProfileRepository>(),
    ),
  );

  sl.registerFactory(
    () => ProfileCubit(profileRepository: sl<ProfileRepository>()),
  );

  await vark_injection.initVark();
}
