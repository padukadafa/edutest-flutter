import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/vark_repository.dart';
import '../../data/models/vark_question_model.dart';

class GetVarkQuestions {
  final VarkRepository repository;

  GetVarkQuestions(this.repository);

  Future<Either<Failure, List<VarkQuestion>>> call() async {
    return await repository.getQuestions();
  }
}

class NoParams {
  const NoParams();
}
