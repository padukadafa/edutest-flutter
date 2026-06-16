import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutest/features/discuss/domain/repositories/discussion_repository.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_event.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_state.dart';

class DiscussionListBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionRepository repository;

  DiscussionListBloc({required this.repository}) : super(DiscussionsLoading()) {
    on<LoadDiscussions>(_onLoadDiscussions);
    on<CreateDiscussion>(_onCreateDiscussion);
    on<ToggleLikeDiscussion>(_onToggleLikeDiscussion);
    on<DeleteDiscussion>(_onDeleteDiscussion);
  }

  Future<void> _onLoadDiscussions(LoadDiscussions event, Emitter<DiscussionState> emit) async {
    await emit.forEach(
      repository.getDiscussions(),
      onData: (either) => either.fold(
        (failure) => DiscussionError(failure.message),
        (discussions) => DiscussionsLoaded(discussions),
      ),
      onError: (error, stackTrace) => DiscussionError(error.toString()),
    );
  }

  Future<void> _onCreateDiscussion(CreateDiscussion event, Emitter<DiscussionState> emit) async {
    final result = await repository.createDiscussion(
      authorId: event.authorId,
      authorName: event.authorName,
      authorPhotoUrl: event.authorPhotoUrl,
      title: event.title,
      content: event.content,
    );
    
    result.fold(
      (failure) => emit(DiscussionActionError(failure.message)),
      (_) => emit(DiscussionCreated()),
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

  Future<void> _onDeleteDiscussion(DeleteDiscussion event, Emitter<DiscussionState> emit) async {
    final result = await repository.deleteDiscussion(
      discussionId: event.discussionId,
      userId: event.userId,
    );
    
    result.fold(
      (failure) => emit(DiscussionActionError(failure.message)),
      (_) => emit(DiscussionCreated()),
    );
  }
}
