import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../entities/cry_analysis.dart';
import '../repositories/cry_analysis_repository.dart';

@injectable
class GetChildCryAnalysesUseCase {
  final CryAnalysisRepository _repository;

  GetChildCryAnalysesUseCase(this._repository);

  Future<Either<Failure, List<CryAnalysis>>> call(int childId) {
    return _repository.getChildCryAnalyses(childId);
  }
}
