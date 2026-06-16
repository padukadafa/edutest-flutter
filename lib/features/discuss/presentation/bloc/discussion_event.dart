import 'package:equatable/equatable.dart';

abstract class DiscussionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDiscussions extends DiscussionEvent {}

class LoadDiscussionDetail extends DiscussionEvent {
  final String discussionId;

  LoadDiscussionDetail(this.discussionId);

  @override
  List<Object?> get props => [discussionId];
}

class LoadReplies extends DiscussionEvent {
  final String discussionId;

  LoadReplies(this.discussionId);

  @override
  List<Object?> get props => [discussionId];
}

class CreateDiscussion extends DiscussionEvent {
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String title;
  final String content;

  CreateDiscussion({
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [authorId, authorName, authorPhotoUrl, title, content];
}

class CreateReply extends DiscussionEvent {
  final String discussionId;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String content;
  final String? parentId;

  CreateReply({
    required this.discussionId,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.content,
    this.parentId,
  });

  @override
  List<Object?> get props => [discussionId, authorId, authorName, authorPhotoUrl, content, parentId];
}

class ToggleLikeDiscussion extends DiscussionEvent {
  final String discussionId;
  final String userId;

  ToggleLikeDiscussion({
    required this.discussionId,
    required this.userId,
  });

  @override
  List<Object?> get props => [discussionId, userId];
}

class ToggleLikeReply extends DiscussionEvent {
  final String discussionId;
  final String replyId;
  final String userId;

  ToggleLikeReply({
    required this.discussionId,
    required this.replyId,
    required this.userId,
  });

  @override
  List<Object?> get props => [discussionId, replyId, userId];
}

class DeleteDiscussion extends DiscussionEvent {
  final String discussionId;
  final String userId;

  DeleteDiscussion({
    required this.discussionId,
    required this.userId,
  });

  @override
  List<Object?> get props => [discussionId, userId];
}
