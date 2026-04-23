import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@injectable
class GetQuestionByIdUseCase {
  final AssessmentRepository repository;

  GetQuestionByIdUseCase(this.repository);

  Future<Either<Failure, Question>> call(int assessmentId, int questionId) {
    return repository.getQuestionById(assessmentId, questionId);
  }
}
