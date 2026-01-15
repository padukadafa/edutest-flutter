import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/ml_prediction.dart';
import '../../domain/repositories/vark_repository.dart';
import '../datasource/vark_local_datasource.dart';
import '../datasource/vark_remote_datasource.dart';
import '../entities/vark_result.dart';
import '../models/vark_question_model.dart';

class VarkRepositoryImpl implements VarkRepository {
  final VarkRemoteDataSource remoteDataSource;
  final VarkLocalDataSource localDataSource;

  VarkRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<VarkQuestion>>> getQuestions() async {
    try {
      final questions = await localDataSource.getQuestions();
      return Right(questions);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get questions: $e'));
    }
  }

  @override
  Future<Either<Failure, VarkResult>> calculateScores(
    Map<String, String> answers,
  ) async {
    try {
      final result = await localDataSource.calculateScores(answers);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to calculate scores: $e'));
    }
  }

  @override
  Future<Either<Failure, MLPrediction>> getPrediction({
    required int visualScore,
    required int auditoryScore,
    required int readingScore,
    required int kinestheticScore,
  }) async {
    try {
      final prediction = await remoteDataSource.getPrediction(
        visualScore: visualScore,
        auditoryScore: auditoryScore,
        readingScore: readingScore,
        kinestheticScore: kinestheticScore,
      );

      return Right(prediction);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkServerHealth() async {
    try {
      final isHealthy = await remoteDataSource.healthCheck();
      return Right(isHealthy);
    } catch (e) {
      return Left(ServerFailure(message: 'Health check failed: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> savePrediction(MLPrediction prediction) async {
    try {
      await localDataSource.savePredictionToDatabase(prediction);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save prediction: $e'));
    }
  }
}
