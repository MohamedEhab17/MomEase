import 'package:equatable/equatable.dart';

class WeeklyFeedingRecordsEntity extends Equatable {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DailyFeedingRecordEntity> dailyRecords;
  final double weeklyAverage;

  const WeeklyFeedingRecordsEntity({
    required this.weekStart,
    required this.weekEnd,
    required this.dailyRecords,
    required this.weeklyAverage,
  });

  @override
  List<Object?> get props => [weekStart, weekEnd, dailyRecords, weeklyAverage];
}

class DailyFeedingRecordEntity extends Equatable {
  final DateTime date;
  final List<FeedingDailyRecordItemEntity> records;

  const DailyFeedingRecordEntity({
    required this.date,
    required this.records,
  });

  @override
  List<Object?> get props => [date, records];
}

class FeedingDailyRecordItemEntity extends Equatable {
  final int timesPerDay;
  final String feedingType;
  final String status;

  const FeedingDailyRecordItemEntity({
    required this.timesPerDay,
    required this.feedingType,
    required this.status,
  });

  @override
  List<Object?> get props => [timesPerDay, feedingType, status];
}
