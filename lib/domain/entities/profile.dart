import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json, String uid) {
    return Profile(
      uid: uid,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      phone: json['phone'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  Profile copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? phone,
  }) {
    return Profile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [uid, name, email, photoUrl, phone, createdAt, updatedAt];
}
