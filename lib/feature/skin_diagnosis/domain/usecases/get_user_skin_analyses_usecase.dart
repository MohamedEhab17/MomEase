import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/repositories/skin_analysis_repository.dart';

@injectable
class GetUserSkinAnalysesUseCase {
  final SkinAnalysisRepository _repository;

  GetUserSkinAnalysesUseCase(this._repository);

  Future<Either<Failure, List<SkinAnalysis>>> call() {
    return _repository.getUserAnalyses();
  }
}
