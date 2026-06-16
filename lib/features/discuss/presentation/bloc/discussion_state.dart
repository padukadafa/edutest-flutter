import 'package:equatable/equatable.dart';
import 'package:edutest/features/discuss/domain/entities/discussion.dart';
import 'package:edutest/features/discuss/domain/entities/discussion_reply.dart';

abstract class DiscussionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiscussionInitial extends DiscussionState {}

class DiscussionsLoading extends DiscussionState {}

class DiscussionsLoaded extends DiscussionState {
  final List<Discussion> discussions;

  DiscussionsLoaded(this.discussions);

  @override
  List<Object?> get props => [discussions];
}

class DiscussionError extends DiscussionState {
  final String message;

  DiscussionError(this.message);

  @override
  List<Object?> get props => [message];
}

class DiscussionDetailLoading extends DiscussionState {}

class DiscussionDetailLoaded extends DiscussionState {
  final Discussion discussion;

  DiscussionDetailLoaded(this.discussion);

  @override
  List<Object?> get props => [discussion];
}

class RepliesLoading extends DiscussionState {}

class RepliesLoaded extends DiscussionState {
  final List<DiscussionReply> replies;

  RepliesLoaded(this.replies);

  @override
  List<Object?> get props => [replies];
}

class DiscussionCreating extends DiscussionState {}

class DiscussionCreated extends DiscussionState {}

class ReplyCreating extends DiscussionState {}

class ReplyCreated extends DiscussionState {}

class DiscussionActionError extends DiscussionState {
  final String message;

  DiscussionActionError(this.message);

  @override
  List<Object?> get props => [message];
}
