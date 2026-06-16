import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutest/features/discuss/domain/entities/discussion_reply.dart';

class DiscussionReplyModel extends DiscussionReply {
  const DiscussionReplyModel({
    required super.id,
    required super.discussionId,
    required super.authorId,
    required super.authorName,
    super.authorPhotoUrl,
    required super.content,
    required super.createdAt,
    super.likesCount,
    super.likedBy,
    super.parentId,
  });

  factory DiscussionReplyModel.fromJson(Map<String, dynamic> json) {
    return DiscussionReplyModel(
      id: json['id'] ?? '',
      discussionId: json['discussionId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorPhotoUrl: json['authorPhotoUrl'],
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likesCount: json['likesCount'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      parentId: json['parentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discussionId': discussionId,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likesCount': likesCount,
      'likedBy': likedBy,
      'parentId': parentId,
    };
  }

  factory DiscussionReplyModel.fromEntity(DiscussionReply entity) {
    return DiscussionReplyModel(
      id: entity.id,
      discussionId: entity.discussionId,
      authorId: entity.authorId,
      authorName: entity.authorName,
      authorPhotoUrl: entity.authorPhotoUrl,
      content: entity.content,
      createdAt: entity.createdAt,
      likesCount: entity.likesCount,
      likedBy: entity.likedBy,
      parentId: entity.parentId,
    );
  }
}
