import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:edutest/domain/entities/profile.dart';
import 'package:edutest/domain/failure.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String uid);

  Future<Either<Failure, Profile>> updateProfile({
    required String uid,
    String? name,
    String? phone,
  });

  Future<Either<Failure, String>> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  });

  Future<Either<Failure, Profile>> updateProfilePhoto({
    required String uid,
    required String photoUrl,
  });
}
