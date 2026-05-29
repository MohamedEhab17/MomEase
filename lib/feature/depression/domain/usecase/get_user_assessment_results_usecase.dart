import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@lazySingleton
class GetUserAssessmentResultsUseCase {
  final AssessmentRepository _repository;

  GetUserAssessmentResultsUseCase(this._repository);

  Future<Either<Failure, List<AssessmentResult>>> call() async {
    return await _repository.getUserAssessmentResults();
  }
}
