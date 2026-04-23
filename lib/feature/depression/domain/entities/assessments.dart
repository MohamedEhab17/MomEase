import 'package:equatable/equatable.dart';

class Assessments extends Equatable{
  final int id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final int totalQuestions;
  final int maxScore;

 const Assessments({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.totalQuestions,
    required this.maxScore,
  });
   @override
  List<Object?> get props => [id, name, nameAr, description, descriptionAr, totalQuestions, maxScore];
}