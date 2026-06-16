import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutest/features/discuss/domain/entities/discussion.dart';

class DiscussionModel extends Discussion {
  const DiscussionModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    super.authorPhotoUrl,
    required super.title,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
    super.likesCount,
    super.repliesCount,
    super.likedBy,
  });

  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
      id: json['id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorPhotoUrl: json['authorPhotoUrl'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      likesCount: json['likesCount'] ?? 0,
      repliesCount: json['repliesCount'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'likesCount': likesCount,
      'repliesCount': repliesCount,
      'likedBy': likedBy,
    };
  }

  factory DiscussionModel.fromEntity(Discussion entity) {
    return DiscussionModel(
      id: entity.id,
      authorId: entity.authorId,
      authorName: entity.authorName,
      authorPhotoUrl: entity.authorPhotoUrl,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likesCount: entity.likesCount,
      repliesCount: entity.repliesCount,
      likedBy: entity.likedBy,
    );
  }
}
