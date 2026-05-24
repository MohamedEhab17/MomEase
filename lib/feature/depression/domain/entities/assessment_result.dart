import 'package:equatable/equatable.dart';

class AssessmentResult extends Equatable {
  final int id;
  final int assessmentId;
  final int score;
  final String severity;
  final String description;
  final String completedAt;
  final List<String> recommendations;

  const AssessmentResult({
    required this.id,
    required this.assessmentId,
    required this.score,
    required this.severity,
    required this.description,
    required this.completedAt,
    required this.recommendations
  });

  @override
  List<Object?> get props => [
        id,
        assessmentId,
        score,
        severity,
        description,
        completedAt,
        recommendations
      ];
}

