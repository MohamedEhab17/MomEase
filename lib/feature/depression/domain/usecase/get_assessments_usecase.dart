import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/assessments.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';
@injectable
class GetAssessmentsUseCase {
  final AssessmentRepository repository;

  GetAssessmentsUseCase(this.repository);

  Future<Either<Failure, List<Assessments>>> call() {
    return repository.getAssessments();
  }
}