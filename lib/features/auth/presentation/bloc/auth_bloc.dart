import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:edutest/domain/repositories/auth_repository.dart';
import 'package:edutest/domain/repositories/profile_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  late final StreamSubscription<User?> _authSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  })  : _authRepository = authRepository,
        _profileRepository = profileRepository,
        super(AuthInitial()) {
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthRegisterSubmitted>(_onAuthRegisterSubmitted);
    on<AuthGoogleSignInSubmitted>(_onAuthGoogleSignInSubmitted);
    on<AuthForgotPasswordSubmitted>(_onAuthForgotPasswordSubmitted);
    on<AuthSignoutRequested>(_onSignout);

    _authSubscription = _authRepository.authStateChanges().listen((user) {
      log('AuthBloc: Auth state changed - ${user?.email ?? "null"}');
      if (user != null && state is! AuthSuccess) {
        log('AuthBloc: Emitting AuthSuccess');
        emit(AuthSuccess());
      } else if (user == null && state is AuthSuccess) {
        log('AuthBloc: Emitting AuthInitial');
        emit(AuthInitial());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> _onAuthRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    log('AuthBloc: Processing registration for ${event.email}');
    emit(AuthLoading());

    try {
      final result = await _authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      result.fold(
        (failure) {
          log('AuthBloc: Registration failed - ${failure.message}');
          emit(AuthFailure(failure.message));
        },
        (uid) async {
          log('AuthBloc: Registration successful, uid: $uid');
          
          log('AuthBloc: Creating profile in Firestore for uid: $uid');
          final profileResult = await _profileRepository.updateProfile(
            uid: uid,
            name: event.name,
            phone: null,
          );

          profileResult.fold(
            (failure) {
              log('AuthBloc: Failed to create profile - ${failure.message}');
            },
            (_) {
              log('AuthBloc: Profile created successfully in Firestore');
            },
          );

          emit(AuthSuccess());
        },
      );
    } catch (e, stackTrace) {
      log('AuthBloc: Unhandled error in registration - $e');
      log('AuthBloc: Stack trace - $stackTrace');
      emit(AuthFailure('Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onAuthGoogleSignInSubmitted(
    AuthGoogleSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    log('AuthBloc: Processing Google Sign-In');
    emit(AuthLoading());

    final result = await _authRepository.loginWithGoogle();

    result.fold(
      (failure) {
        log('AuthBloc: Google Sign-In failed - ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (_) {
        log('AuthBloc: Google Sign-In successful');
        emit(AuthSuccess());
      },
    );
  }

  Future<void> _onAuthForgotPasswordSubmitted(
    AuthForgotPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.sendPasswordResetEmail(
      email: event.email,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(PasswordResetEmailSent()),
    );
  }

  void _onSignout(AuthSignoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
  }
}
