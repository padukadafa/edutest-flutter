import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/vark_repository.dart';
import '../../data/entities/vark_result.dart';

class CalculateVarkScores {
  final VarkRepository repository;

  CalculateVarkScores(this.repository);

  Future<Either<Failure, VarkResult>> call(Map<String, String> answers) async {
    return await repository.calculateScores(answers);
  }
}

class CalculateScoresParams {
  final Map<String, String> answers;

  const CalculateScoresParams({required this.answers});
}
