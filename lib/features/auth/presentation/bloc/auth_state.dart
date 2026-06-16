part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String userId;
  final String userName;
  final String? userPhotoUrl;

  const AuthSuccess({
    this.userId = '',
    this.userName = '',
    this.userPhotoUrl,
  });

  @override
  List<Object?> get props => [userId, userName, userPhotoUrl];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordResetEmailSent extends AuthState {}
