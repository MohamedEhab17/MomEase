import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';

class AssessmentResultModel extends AssessmentResult {
  const AssessmentResultModel({
    required super.id,
    required super.assessmentId,
    required super.score,
    required super.severity,
    required super.description,
    required super.completedAt,
  });

  factory AssessmentResultModel.fromJson(Map<String, dynamic> json) {
    // Handle the wrapper if the whole response is passed
    final data = (json['data'] is Map<String, dynamic>) ? (json['data'] as Map<String, dynamic>) : json;
    
    return AssessmentResultModel(
      id: (data['resultId'] as int?) ?? 0,
      assessmentId: (data['assessmentId'] as int?) ?? 0,
      score: (data['totalScore'] as int?) ?? 0,
      severity: data['levelName']?.toString() ?? '',
      description: data['advice']?.toString() ?? '',
      completedAt: data['completedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': id,
      'assessmentId': assessmentId,
      'totalScore': score,
      'levelName': severity,
      'advice': description,
      'completedAt': completedAt,
    };
  }

  AssessmentResult toEntity() {
    return AssessmentResult(
      id: id,
      assessmentId: assessmentId,
      score: score,
      severity: severity,
      description: description,
      completedAt: completedAt,
    );
  }
}
