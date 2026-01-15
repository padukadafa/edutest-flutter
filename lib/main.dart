import 'package:edutest/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/themes/app_theme.dart';
import 'injection/injection_container.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/shared/pages/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AuthWrapper(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
