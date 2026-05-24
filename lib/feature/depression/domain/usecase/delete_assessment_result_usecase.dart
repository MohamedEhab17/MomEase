import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@lazySingleton
class DeleteAssessmentResultUseCase {
  final AssessmentRepository _repository;

  DeleteAssessmentResultUseCase(this._repository);

  Future<Either<Failure, void>> call(int id) async {
    return await _repository.deleteAssessmentResult(id);
  }
}
