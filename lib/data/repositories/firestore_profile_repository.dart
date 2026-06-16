import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:edutest/domain/entities/profile.dart';
import 'package:edutest/domain/failure.dart';
import 'package:edutest/domain/repositories/profile_repository.dart';

class FirestoreProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  FirestoreProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<Either<Failure, Profile>> getProfile(String uid) async {
    try {
      log('ProfileRepository: Fetching profile for uid: $uid');

      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        log('ProfileRepository: Profile not found, creating new profile');
        final user = _auth.currentUser;
        if (user != null) {
          final newProfile = Profile(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(uid)
              .set(newProfile.toJson());

          return Right(newProfile);
        }
        return const Left(AuthFailure('User not authenticated'));
      }

      final profile = Profile.fromJson(doc.data()!, doc.id);
      log('ProfileRepository: Profile fetched successfully');

      return Right(profile);
    } on FirebaseException catch (e) {
      log('ProfileRepository: FirebaseException - ${e.code}: ${e.message}');
      return Left(ServerFailure('Failed to fetch profile: ${e.message}'));
    } catch (e, stackTrace) {
      log('ProfileRepository: Unexpected error - $e');
      log('ProfileRepository: Stack trace - $stackTrace');
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile({
    required String uid,
    String? name,
    String? phone,
  }) async {
    try {
      log('ProfileRepository: Updating/creating profile for uid: $uid');

      final doc = await _firestore.collection('users').doc(uid).get();

      Profile updatedProfile;

      if (!doc.exists) {
        log('ProfileRepository: Profile not found, creating new profile');
        final user = _auth.currentUser;
        updatedProfile = Profile(
          uid: uid,
          name: name ?? user?.displayName ?? '',
          email: user?.email ?? '',
          photoUrl: user?.photoURL,
          phone: phone,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(uid)
            .set(updatedProfile.toJson());
      } else {
        final currentProfile = Profile.fromJson(doc.data()!, doc.id);
        updatedProfile = currentProfile.copyWith(name: name, phone: phone);

        await _firestore
            .collection('users')
            .doc(uid)
            .update(updatedProfile.toJson());
      }

      if (name != null) {
        await _auth.currentUser?.updateDisplayName(name);
      }

      log('ProfileRepository: Profile updated/created successfully');

      return Right(updatedProfile);
    } on FirebaseException catch (e) {
      log('ProfileRepository: FirebaseException - ${e.code}: ${e.message}');
      return Left(ServerFailure('Failed to update profile: ${e.message}'));
    } catch (e, stackTrace) {
      log('ProfileRepository: Unexpected error - $e');
      log('ProfileRepository: Stack trace - $stackTrace');
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    try {
      log('ProfileRepository: Uploading profile photo for uid: $uid');

      final ref = _storage.ref().child('profile_photos/$uid.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      log('ProfileRepository: Photo uploaded successfully');

      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      log('ProfileRepository: FirebaseException - ${e.code}: ${e.message}');
      return Left(ServerFailure('Failed to upload photo: ${e.message}'));
    } catch (e, stackTrace) {
      log('ProfileRepository: Unexpected error - $e');
      log('ProfileRepository: Stack trace - $stackTrace');
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfilePhoto({
    required String uid,
    required String photoUrl,
  }) async {
    try {
      log('ProfileRepository: Updating profile photo for uid: $uid');

      final doc = await _firestore.collection('users').doc(uid).get();

      Profile updatedProfile;

      if (!doc.exists) {
        log(
          'ProfileRepository: Profile not found, creating new profile with photo',
        );
        final user = _auth.currentUser;
        updatedProfile = Profile(
          uid: uid,
          name: user?.displayName ?? '',
          email: user?.email ?? '',
          photoUrl: photoUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(uid)
            .set(updatedProfile.toJson());
      } else {
        final currentProfile = Profile.fromJson(doc.data()!, doc.id);
        updatedProfile = currentProfile.copyWith(photoUrl: photoUrl);

        await _firestore
            .collection('users')
            .doc(uid)
            .update(updatedProfile.toJson());
      }

      await _auth.currentUser?.updatePhotoURL(photoUrl);

      log('ProfileRepository: Profile photo updated successfully');

      return Right(updatedProfile);
    } on FirebaseException catch (e) {
      log('ProfileRepository: FirebaseException - ${e.code}: ${e.message}');
      return Left(ServerFailure('Failed to update photo: ${e.message}'));
    } catch (e, stackTrace) {
      log('ProfileRepository: Unexpected error - $e');
      log('ProfileRepository: Stack trace - $stackTrace');
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
