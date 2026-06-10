import 'package:equatable/equatable.dart';

class GrowthChartPointEntity extends Equatable {
  final DateTime date;
  final int ageInWeeks;
  final double value;

  const GrowthChartPointEntity({
    required this.date,
    required this.ageInWeeks,
    required this.value,
  });

  @override
  List<Object?> get props => [date, ageInWeeks, value];
}

class GrowthChartDataEntity extends Equatable {
  final String childName;
  final List<GrowthChartPointEntity> weightData;
  final List<GrowthChartPointEntity> heightData;

  const GrowthChartDataEntity({
    required this.childName,
    required this.weightData,
    required this.heightData,
  });

  @override
  List<Object?> get props => [childName, weightData, heightData];
}
