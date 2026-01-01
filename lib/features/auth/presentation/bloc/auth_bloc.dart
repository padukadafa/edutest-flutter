import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(SigninInitial()) {
    on<AuthSubmitted>(_onAuthSubmitted);
    on<AuthSignoutRequested>(_onSignout);
  }

  Future<void> _onAuthSubmitted(
    AuthSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(SigninLoading());

    await Future.delayed(const Duration(seconds: 1));

    if (emit.isDone) return;

    if (event.email == 'admin' && event.password == '1234') {
      emit(SigninSuccess());
    } else {
      emit(const SigninFailure('Email atau password salah'));
    }
  }

  void _onSignout(AuthSignoutRequested event, Emitter<AuthState> emit) {
    emit(SigninInitial());
  }
}
