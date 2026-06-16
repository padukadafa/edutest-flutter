import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:edutest/core/constants/app_constants.dart';
import 'package:edutest/domain/failure.dart';
import 'package:edutest/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  GoogleSignIn? _googleSignIn;
  bool _initialized = false;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  GoogleSignIn get _instance {
    _googleSignIn ??= GoogleSignIn.instance;
    return _googleSignIn!;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _instance.initialize();
      _initialized = true;
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      log('Auth Register: Attempting to register - $email');
      log('Auth Register: Password length - ${password.length}');

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      final user = credential.user;
      if (user == null) {
        return Left(AuthFailure('Failed to create user'));
      }

      log('Auth Register: Registration successful - uid: ${user.uid}');

      return Right(user);
    } on FirebaseAuthException catch (e) {
      log('Auth Register: FirebaseAuthException caught');
      log('Auth Register: Code: ${e.code}');
      log('Auth Register: Message: ${e.message}');
      log('Auth Register: Full error: $e');
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e, stackTrace) {
      log('Auth Register: Unexpected error caught');
      log('Auth Register: Error type: ${e.runtimeType}');
      log('Auth Register: Error: $e');
      log('Auth Register: Stack trace: $stackTrace');
      return Left(AuthFailure('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      log('Auth Login: Attempting to login - $email');

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return Left(AuthFailure('Failed to login'));
      }

      log('Auth Login: Login successful');

      return Right(user);
    } on FirebaseAuthException catch (e) {
      log(
        'Auth Login: FirebaseAuthException - Code: ${e.code}, Message: ${e.message}',
      );
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e, stackTrace) {
      log('Auth Login: Unexpected error - $e');
      log('Auth Login: Stack trace - $stackTrace');
      return Left(AuthFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      log('Google Sign-In: Starting Google Sign-In flow');

      await _ensureInitialized();
      await _instance.signOut();

      final GoogleSignInAccount googleUser = await _instance.authenticate();

      log('Google Sign-In: User selected - ${googleUser.email}');
      log('Google Sign-In: Fetching authentication tokens');

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      log('Google Sign-In: ID token present - ${googleAuth.idToken != null}');

      if (googleAuth.idToken == null) {
        log(
          'Google Sign-In: ID token is null - this is required for Firebase Auth',
        );
        return const Left(AuthFailure('Failed to get Google ID token'));
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      log('Google Sign-In: Signing in to Firebase with Google credential');

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      log(
        'Google Sign-In: Firebase Sign-In successful - ${userCredential.user?.email}',
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left(AuthFailure('Failed to get user'));
      }

      return Right(user);
    } on FirebaseAuthException catch (e) {
      log(
        'Google Sign-In: FirebaseAuthException - Code: ${e.code}, Message: ${e.message}',
      );
      log('Google Sign-In: FirebaseAuthException - Full error: $e');
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e, stackTrace) {
      log('Google Sign-In: Unexpected error - $e');
      log('Google Sign-In: Stack trace - $stackTrace');
      return Left(AuthFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      log('Auth SignOut: Attempting to sign out');

      await _ensureInitialized();
      await Future.wait([_firebaseAuth.signOut(), _instance.signOut()]);

      log('Auth SignOut: Sign out successful');

      return const Right(unit);
    } catch (e, stackTrace) {
      log('Auth SignOut: Error - $e');
      log('Auth SignOut: Stack trace - $stackTrace');
      return Left(AuthFailure('Failed to sign out'));
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An authentication error occurred.';
    }
  }
}
