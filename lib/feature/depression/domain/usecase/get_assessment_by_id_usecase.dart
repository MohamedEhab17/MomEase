import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/assessments.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@injectable
class GetAssessmentByIdUseCase {
  final AssessmentRepository repository;

  GetAssessmentByIdUseCase(this.repository);

  Future<Either<Failure, Assessments>> call(int id) {
    return repository.getAssessmentById(id);
  }
}
