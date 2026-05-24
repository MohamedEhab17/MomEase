import 'package:new_mama/feature/depression/domain/entities/assessments.dart';

class AssessmentsModel extends Assessments {
  const AssessmentsModel({
    required super.id,
    required super.name,
    required super.nameAr,
    required super.description,
    required super.descriptionAr,
    required super.totalQuestions,
    required super.maxScore,
  });

  factory AssessmentsModel.fromJson(Map<String, dynamic> json) {
    return AssessmentsModel(
      id: json['assessmentId'] as int? ?? json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      description: json['description'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      maxScore: json['maxScore'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'totalQuestions': totalQuestions,
      'maxScore': maxScore,
    };
  }

  Assessments toEntity() {
    return Assessments(
      id: id,
      name: name,
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      totalQuestions: totalQuestions,
      maxScore: maxScore,
    );
  }
}