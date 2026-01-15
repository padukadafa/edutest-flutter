import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'injection_vark.dart' as vark_injection;

final sl = GetIt.instance;

Future<void> initInjection() async {
  // Register Blocs
  sl.registerFactory(() => AuthBloc());

  // Initialize VARK dependencies
  await vark_injection.initVark();
}
