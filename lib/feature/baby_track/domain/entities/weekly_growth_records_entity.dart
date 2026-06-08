import 'package:equatable/equatable.dart';

class DailyGrowthEntity extends Equatable {
  final DateTime date;
  final double? weight;
  final double? height;
  final String status;

  const DailyGrowthEntity({
    required this.date,
    this.weight,
    this.height,
    required this.status,
  });

  @override
  List<Object?> get props => [date, weight, height, status];
}

class WeeklyGrowthRecordsEntity extends Equatable {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DailyGrowthEntity> dailyGrowth;
  final double weeklyWeightGain;
  final double weeklyHeightGain;
  final int totalRecords;

  const WeeklyGrowthRecordsEntity({
    required this.weekStart,
    required this.weekEnd,
    required this.dailyGrowth,
    required this.weeklyWeightGain,
    required this.weeklyHeightGain,
    required this.totalRecords,
  });

  @override
  List<Object?> get props => [
        weekStart,
        weekEnd,
        dailyGrowth,
        weeklyWeightGain,
        weeklyHeightGain,
        totalRecords,
      ];
}
