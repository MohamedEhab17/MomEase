import 'package:equatable/equatable.dart';
import 'weekly_sleep_records_entity.dart';

class MonthlySleepRecordsEntity extends Equatable {
  final int year;
  final int month;
  final String monthName;
  final List<DailySleepRecordEntity> dailySleep;
  final String monthlyAverageSleep;
  final int totalRecords;
  final int goodDays;
  final int poorDays;

  const MonthlySleepRecordsEntity({
    required this.year,
    required this.month,
    required this.monthName,
    required this.dailySleep,
    required this.monthlyAverageSleep,
    required this.totalRecords,
    required this.goodDays,
    required this.poorDays,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        monthName,
        dailySleep,
        monthlyAverageSleep,
        totalRecords,
        goodDays,
        poorDays,
      ];
}
