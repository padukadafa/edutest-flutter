import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initInjection() {
  // Register Blocs
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(() => VarkBloc());
}
