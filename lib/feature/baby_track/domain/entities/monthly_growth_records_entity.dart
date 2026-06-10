import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';

class MonthlyGrowthRecordsEntity extends Equatable {
  final int year;
  final int month;
  final String monthName;
  final List<DailyGrowthEntity> dailyGrowth;
  final double monthlyWeightGain;
  final double monthlyHeightGain;
  final int totalRecords;
  final int goodGrowthDays;
  final int poorGrowthDays;

  const MonthlyGrowthRecordsEntity({
    required this.year,
    required this.month,
    required this.monthName,
    required this.dailyGrowth,
    required this.monthlyWeightGain,
    required this.monthlyHeightGain,
    required this.totalRecords,
    required this.goodGrowthDays,
    required this.poorGrowthDays,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        monthName,
        dailyGrowth,
        monthlyWeightGain,
        monthlyHeightGain,
        totalRecords,
        goodGrowthDays,
        poorGrowthDays,
      ];
}
