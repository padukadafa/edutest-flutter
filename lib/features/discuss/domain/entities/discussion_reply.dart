import 'package:equatable/equatable.dart';

class DiscussionReply extends Equatable {
  final String id;
  final String discussionId;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final List<String> likedBy;
  final String? parentId;

  const DiscussionReply({
    required this.id,
    required this.discussionId,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.likedBy = const [],
    this.parentId,
  });

  bool isLikedBy(String userId) => likedBy.contains(userId);

  bool get isReply => parentId != null;

  @override
  List<Object?> get props => [
        id,
        discussionId,
        authorId,
        authorName,
        authorPhotoUrl,
        content,
        createdAt,
        likesCount,
        likedBy,
        parentId,
      ];
}
