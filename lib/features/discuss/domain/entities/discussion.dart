import 'package:equatable/equatable.dart';

class Discussion extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int repliesCount;
  final List<String> likedBy;

  const Discussion({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.likesCount = 0,
    this.repliesCount = 0,
    this.likedBy = const [],
  });

  bool isLikedBy(String userId) => likedBy.contains(userId);

  @override
  List<Object?> get props => [
        id,
        authorId,
        authorName,
        authorPhotoUrl,
        title,
        content,
        createdAt,
        updatedAt,
        likesCount,
        repliesCount,
        likedBy,
      ];
}
