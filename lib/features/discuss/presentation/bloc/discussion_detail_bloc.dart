import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutest/features/discuss/domain/repositories/discussion_repository.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_event.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_state.dart';

class DiscussionDetailBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionRepository repository;

  DiscussionDetailBloc({required this.repository}) : super(DiscussionDetailLoading()) {
    on<LoadDiscussionDetail>(_onLoadDiscussionDetail);
    on<LoadReplies>(_onLoadReplies);
    on<CreateReply>(_onCreateReply);
    on<ToggleLikeDiscussion>(_onToggleLikeDiscussion);
    on<ToggleLikeReply>(_onToggleLikeReply);
  }

  Future<void> _onLoadDiscussionDetail(LoadDiscussionDetail event, Emitter<DiscussionState> emit) async {
    await emit.forEach(
      repository.getDiscussionDetail(event.discussionId),
      onData: (either) => either.fold(
        (failure) => DiscussionError(failure.message),
        (discussion) => DiscussionDetailLoaded(discussion),
      ),
      onError: (error, stackTrace) => DiscussionError(error.toString()),
    );
  }

  Future<void> _onLoadReplies(LoadReplies event, Emitter<DiscussionState> emit) async {
    await emit.forEach(
      repository.getReplies(event.discussionId),
      onData: (either) => either.fold(
        (failure) => DiscussionError(failure.message),
        (replies) => RepliesLoaded(replies),
      ),
      onError: (error, stackTrace) => DiscussionError(error.toString()),
    );
  }

  Future<void> _onCreateReply(CreateReply event, Emitter<DiscussionState> emit) async {
    final result = await repository.createReply(
      discussionId: event.discussionId,
      authorId: event.authorId,
      authorName: event.authorName,
      authorPhotoUrl: event.authorPhotoUrl,
      content: event.content,
      parentId: event.parentId,
    );
    
    result.fold(
      (failure) => emit(DiscussionActionError(failure.message)),
      (_) => emit(ReplyCreated()),
    );
  }

  Future<void> _onToggleLikeDiscussion(ToggleLikeDiscussion event, Emitter<DiscussionState> emit) async {
    final result = await repository.toggleLikeDiscussion(
      discussionId: event.discussionId,
      userId: event.userId,
    );
    
    result.fold(
      (failure) => emit(DiscussionActionError(failure.message)),
      (_) {},
    );
  }

  Future<void> _onToggleLikeReply(ToggleLikeReply event, Emitter<DiscussionState> emit) async {
    final result = await repository.toggleLikeReply(
      discussionId: event.discussionId,
      replyId: event.replyId,
      userId: event.userId,
    );
    
    result.fold(
      (failure) => emit(DiscussionActionError(failure.message)),
      (_) {},
    );
  }
}
