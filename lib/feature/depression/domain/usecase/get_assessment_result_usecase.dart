import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@injectable
class GetAssessmentResultUseCase {
  final AssessmentRepository repository;

  GetAssessmentResultUseCase(this.repository);

  Future<Either<Failure, AssessmentResult>> call(int id) {
    return repository.getAssessmentResult(id);
  }
}
