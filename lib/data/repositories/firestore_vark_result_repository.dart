import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:edutest/domain/entities/vark_test_result.dart';
import 'package:edutest/domain/failure.dart';
import 'package:edutest/domain/repositories/vark_result_repository.dart';

class FirestoreVarkResultRepository implements VarkResultRepository {
  final FirebaseFirestore _firestore;

  FirestoreVarkResultRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, Unit>> saveResult(VarkTestResult result) async {
    try {
      log('VarkResultRepository: Saving result for uid: ${result.uid}');

      final docRef = await _firestore
          .collection('vark_results')
          .add(result.toFirestore());

      log('VarkResultRepository: Result saved with id: ${docRef.id}');

      return const Right(unit);
    } on FirebaseException catch (e) {
      log('VarkResultRepository: FirebaseException - ${e.code}: ${e.message}');
      return Left(ServerFailure('Failed to save result: ${e.message}'));
    } catch (e, stackTrace) {
      log('VarkResultRepository: Unexpected error - $e');
      log('VarkResultRepository: Stack trace - $stackTrace');
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<VarkTestResult>>> getResults(String uid) async {
    try {
      log('VarkResultRepository: Fetching results for uid: $uid');

      final snapshot = await _firestore
          .collection('vark_results')
          .where('uid', isEqualTo: uid)
          .orderBy('completedAt', descending: true)
          .get();

      final results = snapshot.docs
          .map((doc) => VarkTestResult.fromFirestore(doc.id, doc.data()))
          .toList();

      log('VarkResultRepository: Found ${results.length} results');

      return Right(results);
    } on FirebaseException catch (e) {
      log('VarkResultRepository: FirebaseException - ${e.code}: ${e.message}');
      return Left(ServerFailure('Failed to fetch results: ${e.message}'));
    } catch (e, stackTrace) {
      log('VarkResultRepository: Unexpected error - $e');
      log('VarkResultRepository: Stack trace - $stackTrace');
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
