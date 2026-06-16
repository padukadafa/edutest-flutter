part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthRegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class AuthGoogleSignInSubmitted extends AuthEvent {}

class AuthForgotPasswordSubmitted extends AuthEvent {
  final String email;

  const AuthForgotPasswordSubmitted({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthSignoutRequested extends AuthEvent {}
