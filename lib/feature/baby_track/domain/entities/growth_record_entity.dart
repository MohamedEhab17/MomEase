import 'package:equatable/equatable.dart';

class GrowthRecordEntity extends Equatable {
  final int growthId;
  final String childName;
  final DateTime recordDate;
  final int ageInWeeks;
  final int ageInMonths;
  final double weightKg;
  final double heightCm;

  const GrowthRecordEntity({
    required this.growthId,
    required this.childName,
    required this.recordDate,
    required this.ageInWeeks,
    required this.ageInMonths,
    required this.weightKg,
    required this.heightCm,
  });

  @override
  List<Object?> get props => [
        growthId,
        childName,
        recordDate,
        ageInWeeks,
        ageInMonths,
        weightKg,
        heightCm,
      ];
}
