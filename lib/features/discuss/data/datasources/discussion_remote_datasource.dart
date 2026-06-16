import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutest/features/discuss/data/models/discussion_model.dart';
import 'package:edutest/features/discuss/data/models/discussion_reply_model.dart';

class DiscussionRemoteDatasource {
  final FirebaseFirestore firestore;

  DiscussionRemoteDatasource({required this.firestore});

  Stream<List<DiscussionModel>> getDiscussions() {
    return firestore
        .collection('discussions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiscussionModel.fromJson(doc.data()))
            .toList());
  }

  Stream<DiscussionModel> getDiscussionDetail(String discussionId) {
    return firestore
        .collection('discussions')
        .doc(discussionId)
        .snapshots()
        .map((doc) => DiscussionModel.fromJson(doc.data()!));
  }

  Stream<List<DiscussionReplyModel>> getReplies(String discussionId) {
    return firestore
        .collection('discussions')
        .doc(discussionId)
        .collection('replies')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiscussionReplyModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> createDiscussion(DiscussionModel discussion) {
    return firestore
        .collection('discussions')
        .doc(discussion.id)
        .set(discussion.toJson());
  }

  Future<void> createReply(String discussionId, DiscussionReplyModel reply) async {
    final discussionRef = firestore.collection('discussions').doc(discussionId);
    final replyRef = discussionRef.collection('replies').doc(reply.id);
    
    await firestore.runTransaction((transaction) async {
      transaction.set(replyRef, reply.toJson());
      transaction.update(discussionRef, {
        'repliesCount': FieldValue.increment(1),
      });
    });
  }

  Future<void> toggleLikeDiscussion(String discussionId, String userId) async {
    final doc = firestore.collection('discussions').doc(discussionId);
    
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      if (!snapshot.exists) return;
      
      final data = snapshot.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? []);
      
      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }
      
      transaction.update(doc, {
        'likedBy': likedBy,
        'likesCount': likedBy.length,
      });
    });
  }

  Future<void> toggleLikeReply({
    required String discussionId,
    required String replyId,
    required String userId,
  }) async {
    final doc = firestore
        .collection('discussions')
        .doc(discussionId)
        .collection('replies')
        .doc(replyId);
    
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      if (!snapshot.exists) return;
      
      final data = snapshot.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? []);
      
      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }
      
      transaction.update(doc, {
        'likedBy': likedBy,
        'likesCount': likedBy.length,
      });
    });
  }

  Future<void> deleteDiscussion(String discussionId) async {
    final discussionRef = firestore.collection('discussions').doc(discussionId);
    final repliesRef = discussionRef.collection('replies');
    
    await firestore.runTransaction((transaction) async {
      final repliesSnapshot = await repliesRef.get();
      for (final replyDoc in repliesSnapshot.docs) {
        transaction.delete(replyDoc.reference);
      }
      transaction.delete(discussionRef);
    });
  }
}
