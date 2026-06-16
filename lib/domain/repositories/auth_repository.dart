import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edutest/domain/failure.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  User? get currentUser;

  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithGoogle();

  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, Unit>> signOut();
}
