import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@injectable
class GetQuestionsUseCase {
  final AssessmentRepository repository;

  GetQuestionsUseCase(this.repository);

  Future<Either<Failure, List<Question>>> call(int assessmentId) {
    return repository.getQuestions(assessmentId);
  }
}
