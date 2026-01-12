import 'package:dartz/dartz.dart';
import 'package:edutest/core/error/failure.dart';
import 'package:edutest/features/question/data/datasource/vark_local_datasource.dart';
import 'package:edutest/features/question/data/datasource/vark_remote_datasource.dart';
import 'package:edutest/features/question/data/entities/vark_result.dart';
import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:edutest/features/question/domain/entities/ml_prediction.dart';
import 'package:edutest/features/question/domain/repositories/vark_repository.dart';

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
      return Left(CacheFailure(message: e.toString()));
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
      return Left(CacheFailure(message: e.toString()));
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

      // Save to local cache
      await localDataSource.cachePrediction(prediction);

      return Right(prediction);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> savePrediction(MLPrediction prediction) async {
    try {
      await localDataSource.savePredictionToDatabase(prediction);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
