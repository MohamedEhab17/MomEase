import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/repositories/skin_analysis_repository.dart';

class AnalyzeImageParams {
  final File image;
  final int childId;

  const AnalyzeImageParams({required this.image, required this.childId});
}

@injectable
class AnalyzeSkinImageUseCase {
  final SkinAnalysisRepository _repository;

  AnalyzeSkinImageUseCase(this._repository);

  Future<Either<Failure, SkinAnalysis>> call(AnalyzeImageParams params) {
    return _repository.analyzeImage(
      image: params.image,
      childId: params.childId,
    );
  }
}
