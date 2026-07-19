import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../repositories/cry_analysis_repository.dart';

@injectable
class DeleteCryAnalysisUseCase {
  final CryAnalysisRepository _repository;

  DeleteCryAnalysisUseCase(this._repository);

  Future<Either<Failure, void>> call(int cryId) {
    return _repository.deleteCryAnalysis(cryId);
  }
}
