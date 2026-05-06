import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';

abstract class SkinAnalysisRepository {
  Future<Either<Failure, SkinAnalysis>> analyzeImage({
    required File image,
    required int childId,
  });

  Future<Either<Failure, List<SkinAnalysis>>> getUserAnalyses();

  Future<Either<Failure, List<SkinAnalysis>>> getChildAnalyses(int childId);

  Future<Either<Failure, void>> deleteAnalysis(int analysisId);
}
