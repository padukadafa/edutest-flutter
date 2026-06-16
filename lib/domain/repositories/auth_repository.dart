import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edutest/domain/failure.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();

  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> loginWithGoogle();

  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, Unit>> signOut();
}
