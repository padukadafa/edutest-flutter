import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../entities/ml_prediction.dart';
import '../repositories/vark_repository.dart';

class GetMLPrediction {
  final VarkRepository repository;

  GetMLPrediction(this.repository);

  Future<Either<Failure, MLPrediction>> call(MLPredictionParams params) async {
    return await repository.getPrediction(
      visualScore: params.visualScore,
      auditoryScore: params.auditoryScore,
      readingScore: params.readingScore,
      kinestheticScore: params.kinestheticScore,
    );
  }

  /// Health check method
  Future<Either<Failure, bool>> checkHealth() async {
    return await repository.checkServerHealth();
  }
}

class MLPredictionParams extends Equatable {
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

  @override
  List<Object?> get props => [
    visualScore,
    auditoryScore,
    readingScore,
    kinestheticScore,
  ];
}
