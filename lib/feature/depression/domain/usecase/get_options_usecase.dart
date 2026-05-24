import 'package:dartz/dartz.dart' hide Option;
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/option.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@injectable
class GetOptionsUseCase {
  final AssessmentRepository repository;

  GetOptionsUseCase(this.repository);

  Future<Either<Failure, List<Option>>> call(int questionId) {
    return repository.getOptions(questionId);
  }

}
