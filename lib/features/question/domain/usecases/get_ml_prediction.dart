import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/vark_repository.dart';
import '../entities/ml_prediction.dart';

class GetMLPrediction {
  final VarkRepository repository;

  GetMLPrediction(this.repository);

  Future<Either<Failure, MLPrediction>> call({
    required int visualScore,
    required int auditoryScore,
    required int readingScore,
    required int kinestheticScore,
  }) async {
    return await repository.getPrediction(
      visualScore: visualScore,
      auditoryScore: auditoryScore,
      readingScore: readingScore,
      kinestheticScore: kinestheticScore,
    );
  }
}

class MLPredictionParams {
  final int visualScore;
  final int auditoryScore;
  final int readingScore;
  final int kinestheticScore;

  const MLPredictionParams({
    required this.visualScore,
    required this.auditoryScore,
    required this.readingScore,
    required this.kinestheticScore,
  });
}
