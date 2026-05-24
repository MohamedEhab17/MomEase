import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';

class SkinAnalysisModel {
  final int skinAnalysisId;
  final String imageUrl;
  final String result;
  final String diseaseName;
  final String advice;
  final double confidence;
  final DateTime createdAt;

  const SkinAnalysisModel({
    required this.skinAnalysisId,
    required this.imageUrl,
    required this.result,
    required this.diseaseName,
    required this.advice,
    required this.confidence,
    required this.createdAt,
  });

  factory SkinAnalysisModel.fromJson(Map<String, dynamic> json) {
    return SkinAnalysisModel(
      skinAnalysisId: json['skinanalysisId'] as int,
      imageUrl: json['imageUrl'] as String? ?? '',
      result: json['result'] as String? ?? '',
      diseaseName: json['diseaseName'] as String? ?? '',
      advice: json['advice'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  SkinAnalysis toEntity() {
    return SkinAnalysis(
      skinAnalysisId: skinAnalysisId,
      imageUrl: imageUrl,
      result: result,
      diseaseName: diseaseName,
      advice: advice,
      confidence: confidence,
      createdAt: createdAt,
    );
  }
}
