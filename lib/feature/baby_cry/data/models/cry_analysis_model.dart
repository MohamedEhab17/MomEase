import '../../domain/entities/cry_analysis.dart';

class CryAnalysisModel {
  final int cryId;
  final String audioUrl;
  final String result;
  final double confidence;
  final String advice;
  final int childId;
  final DateTime createdAt;
  final Map<String, double>? allScores;

  const CryAnalysisModel({
    required this.cryId,
    required this.audioUrl,
    required this.result,
    required this.confidence,
    required this.advice,
    required this.childId,
    required this.createdAt,
    this.allScores,
  });

  factory CryAnalysisModel.fromJson(Map<String, dynamic> json) {
    Map<String, double>? parsedScores;
    if (json['allScores'] is Map<String, dynamic>) {
      parsedScores = {};
      (json['allScores'] as Map<String, dynamic>).forEach((key, value) {
        parsedScores![key] = (value as num).toDouble();
      });
    }

    return CryAnalysisModel(
      cryId: json['cryId'] as int,
      audioUrl: json['audioUrl'] as String? ?? '',
      result: json['result'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      advice: json['advice'] as String? ?? '',
      childId: json['childId'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      allScores: parsedScores,
    );
  }

  CryAnalysis toEntity() {
    return CryAnalysis(
      cryId: cryId,
      audioUrl: audioUrl,
      result: result,
      confidence: confidence,
      advice: advice,
      childId: childId,
      createdAt: createdAt,
      allScores: allScores,
    );
  }
}
