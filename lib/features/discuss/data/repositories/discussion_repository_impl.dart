import 'package:dartz/dartz.dart';
import 'package:edutest/core/error/failure.dart';
import 'package:edutest/features/discuss/data/datasources/discussion_remote_datasource.dart';
import 'package:edutest/features/discuss/data/models/discussion_model.dart';
import 'package:edutest/features/discuss/data/models/discussion_reply_model.dart';
import 'package:edutest/features/discuss/domain/entities/discussion.dart';
import 'package:edutest/features/discuss/domain/entities/discussion_reply.dart';
import 'package:edutest/features/discuss/domain/repositories/discussion_repository.dart';
import 'package:uuid/uuid.dart';

class DiscussionRepositoryImpl implements DiscussionRepository {
  final DiscussionRemoteDatasource remoteDatasource;
  final Uuid uuid;

  DiscussionRepositoryImpl({
    required this.remoteDatasource,
    required this.uuid,
  });

  @override
  Stream<Either<Failure, List<Discussion>>> getDiscussions() {
    return remoteDatasource.getDiscussions().map(
      (discussions) => Right<Failure, List<Discussion>>(discussions),
    ).handleError((error, stackTrace) {
      return Left<Failure, List<Discussion>>(ServerFailure(message: error.toString()));
    });
  }

  @override
  Stream<Either<Failure, Discussion>> getDiscussionDetail(String discussionId) {
    return remoteDatasource.getDiscussionDetail(discussionId).map(
      (discussion) => Right<Failure, Discussion>(discussion),
    ).handleError((error, stackTrace) {
      return Left<Failure, Discussion>(ServerFailure(message: error.toString()));
    });
  }

  @override
  Stream<Either<Failure, List<DiscussionReply>>> getReplies(String discussionId) {
    return remoteDatasource.getReplies(discussionId).map(
      (replies) => Right<Failure, List<DiscussionReply>>(replies),
    ).handleError((error, stackTrace) {
      return Left<Failure, List<DiscussionReply>>(ServerFailure(message: error.toString()));
    });
  }

  @override
  Future<Either<Failure, void>> createDiscussion({
    required String authorId,
    required String authorName,
    String? authorPhotoUrl,
    required String title,
    required String content,
  }) async {
    try {
      final now = DateTime.now();
      final discussion = DiscussionModel(
        id: uuid.v4(),
        authorId: authorId,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );
      await remoteDatasource.createDiscussion(discussion);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createReply({
    required String discussionId,
    required String authorId,
    required String authorName,
    String? authorPhotoUrl,
    required String content,
    String? parentId,
  }) async {
    try {
      final reply = DiscussionReplyModel(
        id: uuid.v4(),
        discussionId: discussionId,
        authorId: authorId,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        content: content,
        createdAt: DateTime.now(),
        parentId: parentId,
      );
      await remoteDatasource.createReply(discussionId, reply);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleLikeDiscussion({
    required String discussionId,
    required String userId,
  }) async {
    try {
      await remoteDatasource.toggleLikeDiscussion(discussionId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleLikeReply({
    required String discussionId,
    required String replyId,
    required String userId,
  }) async {
    try {
      await remoteDatasource.toggleLikeReply(
        discussionId: discussionId,
        replyId: replyId,
        userId: userId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiscussion({
    required String discussionId,
    required String userId,
  }) async {
    try {
      await remoteDatasource.deleteDiscussion(discussionId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
