import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:edutest/shared/pages/menu_nav_shell.dart';
import 'package:edutest/features/auth/presentation/pages/signin_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final uid = snapshot.data!.uid;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ProfileCubit>().loadProfile(uid);
          });

          return const MenuNavShell();
        }

        return const SigninPage();
      },
    );
  }
}
