import 'dart:io';
import '../models/cry_analysis_model.dart';

abstract class CryAnalysisRemoteDataSource {
  Future<CryAnalysisModel> analyzeCry({
    required File audioFile,
    required int childId,
  });

  Future<List<CryAnalysisModel>> getUserCryAnalyses();

  Future<List<CryAnalysisModel>> getChildCryAnalyses(int childId);

  Future<void> deleteCryAnalysis(int cryId);
}
