import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutest/domain/entities/profile.dart';
import 'package:edutest/domain/repositories/profile_repository.dart';

part 'profile_state.dart';
part 'profile_event.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  StreamSubscription? _authSubscription;

  ProfileCubit({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileInitial());

  Future<void> loadProfile(String uid) async {
    log('ProfileCubit: Loading profile for uid: $uid');
    emit(ProfileLoading());

    final result = await _profileRepository.getProfile(uid);

    result.fold(
      (failure) {
        log('ProfileCubit: Failed to load profile - ${failure.message}');
        emit(ProfileFailure(failure.message));
      },
      (profile) {
        log('ProfileCubit: Profile loaded successfully');
        emit(ProfileLoaded(profile));
      },
    );
  }

  Future<void> updateProfile({
    required String uid,
    String? name,
    String? phone,
  }) async {
    log('ProfileCubit: Updating profile');
    emit(ProfileUpdating());

    final result = await _profileRepository.updateProfile(
      uid: uid,
      name: name,
      phone: phone,
    );

    result.fold(
      (failure) {
        log('ProfileCubit: Failed to update profile - ${failure.message}');
        emit(ProfileFailure(failure.message));
      },
      (profile) {
        log('ProfileCubit: Profile updated successfully');
        emit(ProfileLoaded(profile));
      },
    );
  }

  Future<void> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    log('ProfileCubit: Uploading profile photo');
    emit(ProfileUpdating());

    final uploadResult = await _profileRepository.uploadProfilePhoto(
      uid: uid,
      imageFile: imageFile,
    );

    uploadResult.fold(
      (failure) {
        log('ProfileCubit: Failed to upload photo - ${failure.message}');
        emit(ProfileFailure(failure.message));
      },
      (photoUrl) async {
        final updateResult = await _profileRepository.updateProfilePhoto(
          uid: uid,
          photoUrl: photoUrl,
        );

        updateResult.fold(
          (failure) {
            log('ProfileCubit: Failed to update photo URL - ${failure.message}');
            emit(ProfileFailure(failure.message));
          },
          (profile) {
            log('ProfileCubit: Profile photo updated successfully');
            emit(ProfileLoaded(profile));
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
