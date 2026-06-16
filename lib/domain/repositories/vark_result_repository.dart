import 'package:dartz/dartz.dart';
import 'package:edutest/domain/entities/vark_test_result.dart';
import 'package:edutest/domain/failure.dart';

abstract class VarkResultRepository {
  Future<Either<Failure, Unit>> saveResult(VarkTestResult result);

  Future<Either<Failure, List<VarkTestResult>>> getResults(String uid);
}
