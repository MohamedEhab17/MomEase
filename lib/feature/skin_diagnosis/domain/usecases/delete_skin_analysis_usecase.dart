import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/repositories/skin_analysis_repository.dart';

@injectable
class DeleteSkinAnalysisUseCase {
  final SkinAnalysisRepository _repository;

  DeleteSkinAnalysisUseCase(this._repository);

  Future<Either<Failure, void>> call(int analysisId) {
    return _repository.deleteAnalysis(analysisId);
  }
}
