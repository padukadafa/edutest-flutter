part of 'profile_cubit.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String uid;

  const LoadProfile(this.uid);

  @override
  List<Object?> get props => [uid];
}

class UpdateProfile extends ProfileEvent {
  final String uid;
  final String? name;
  final String? phone;

  const UpdateProfile({
    required this.uid,
    this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [uid, name, phone];
}

class UploadProfilePhoto extends ProfileEvent {
  final String uid;
  final File imageFile;

  const UploadProfilePhoto({
    required this.uid,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [uid, imageFile];
}
