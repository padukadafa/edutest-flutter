import 'package:dartz/dartz.dart';
import 'package:edutest/core/error/failure.dart';
import 'package:edutest/features/discuss/domain/entities/discussion.dart';
import 'package:edutest/features/discuss/domain/entities/discussion_reply.dart';

abstract class DiscussionRepository {
  Stream<Either<Failure, List<Discussion>>> getDiscussions();
  Stream<Either<Failure, Discussion>> getDiscussionDetail(String discussionId);
  Future<Either<Failure, void>> createDiscussion({
    required String authorId,
    required String authorName,
    String? authorPhotoUrl,
    required String title,
    required String content,
  });
  Future<Either<Failure, void>> createReply({
    required String discussionId,
    required String authorId,
    required String authorName,
    String? authorPhotoUrl,
    required String content,
    String? parentId,
  });
  Future<Either<Failure, void>> toggleLikeDiscussion({
    required String discussionId,
    required String userId,
  });
  Future<Either<Failure, void>> toggleLikeReply({
    required String discussionId,
    required String replyId,
    required String userId,
  });
  Stream<Either<Failure, List<DiscussionReply>>> getReplies(String discussionId);
  Future<Either<Failure, void>> deleteDiscussion({
    required String discussionId,
    required String userId,
  });
}
