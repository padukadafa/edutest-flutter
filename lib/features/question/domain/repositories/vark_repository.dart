import 'package:dartz/dartz.dart';
import 'package:edutest/core/error/failure.dart';
import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:edutest/features/question/domain/entities/ml_prediction.dart';
import '../../data/entities/vark_result.dart';

abstract class VarkRepository {
  Future<Either<Failure, List<VarkQuestion>>> getQuestions();
  Future<Either<Failure, VarkResult>> calculateScores(
    Map<String, String> answers,
  );
  Future<Either<Failure, MLPrediction>> getPrediction({
    required int visualScore,
    required int auditoryScore,
    required int readingScore,
    required int kinestheticScore,
  });
  Future<Either<Failure, bool>> savePrediction(MLPrediction prediction);
}
