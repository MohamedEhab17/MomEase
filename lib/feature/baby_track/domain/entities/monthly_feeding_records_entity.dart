import 'package:equatable/equatable.dart';
import 'weekly_feeding_records_entity.dart';

class MonthlyFeedingRecordsEntity extends Equatable {
  final int year;
  final int month;
  final String monthName;
  final List<DailyFeedingRecordEntity> dailyRecords;
  final double monthlyAverageTimesPerDay;
  final int totalRecords;
  final int normalDays;
  final int abnormalDays;

  const MonthlyFeedingRecordsEntity({
    required this.year,
    required this.month,
    required this.monthName,
    required this.dailyRecords,
    required this.monthlyAverageTimesPerDay,
    required this.totalRecords,
    required this.normalDays,
    required this.abnormalDays,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        monthName,
        dailyRecords,
        monthlyAverageTimesPerDay,
        totalRecords,
        normalDays,
        abnormalDays,
      ];
}
