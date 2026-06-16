import 'package:edutest/data/repositories/firebase_auth_repository.dart';
import 'package:edutest/domain/repositories/auth_repository.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // Register Firebase Auth Repository
  sl.registerFactory<AuthRepository>(
    () => FirebaseAuthRepository(),
  );

  // Register Blocs
  sl.registerFactory(
    () => AuthBloc(authRepository: sl<AuthRepository>()),
  );
}
