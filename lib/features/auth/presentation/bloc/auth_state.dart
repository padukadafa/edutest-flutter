part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends AuthState {}

class SigninLoading extends AuthState {}

class SigninSuccess extends AuthState {}

class SigninFailure extends AuthState {
  final String message;
  const SigninFailure(this.message);

  @override
  List<Object> get props => [message];
}
