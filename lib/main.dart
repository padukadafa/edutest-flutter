import 'package:edutest/core/routes/route_name.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/features/auth/presentation/pages/signin_page.dart'
    show LoginPage, SigninPage;
import 'package:edutest/shared/pages/menu_nav_shell.dart';
import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/themes/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'injection/injection_container.dart';

void main() {
  initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<VarkBloc>(create: (_) => sl<VarkBloc>()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),

            home: () {
              if (state is SigninSuccess) {
                return const MenuNavShell();
              }
              return const SigninPage();
            }(),
          );
        },
      ),
    );
  }
}
