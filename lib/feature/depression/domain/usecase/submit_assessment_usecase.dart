import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';
import 'package:new_mama/feature/depression/domain/entities/submit_request.dart';

import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@injectable
class SubmitAssessmentUseCase {
  final AssessmentRepository repository;

  SubmitAssessmentUseCase(this.repository);

  Future<Either<Failure, AssessmentResult>> call(int assessmentId, SubmitRequest request) {

    return repository.submitAssessment(assessmentId, request);
  }

}
