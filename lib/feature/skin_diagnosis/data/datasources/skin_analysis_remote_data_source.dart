import 'dart:io';
import 'package:new_mama/feature/skin_diagnosis/data/models/skin_analysis_model.dart';

abstract class SkinAnalysisRemoteDataSource {
  Future<SkinAnalysisModel> analyzeImage({
    required File image,
    required int childId,
  });

  Future<List<SkinAnalysisModel>> getUserAnalyses();

  Future<List<SkinAnalysisModel>> getChildAnalyses(int childId);

  Future<void> deleteAnalysis(int analysisId);
}
