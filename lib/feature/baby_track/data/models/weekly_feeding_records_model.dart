import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';

class WeeklyFeedingRecordsModel extends WeeklyFeedingRecordsEntity {
  const WeeklyFeedingRecordsModel({
    required super.weekStart,
    required super.weekEnd,
    required super.dailyRecords,
    required super.weeklyAverage,
  });

  factory WeeklyFeedingRecordsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyFeedingRecordsModel(
      weekStart: json['weekStart'] != null
          ? DateTime.parse(json['weekStart'] as String)
          : DateTime.now(),
      weekEnd: json['weekEnd'] != null
          ? DateTime.parse(json['weekEnd'] as String)
          : DateTime.now(),
      dailyRecords: (json['dailyRecords'] as List<dynamic>?)
              ?.map((e) => DailyFeedingRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weeklyAverage: (json['weeklyAverage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DailyFeedingRecordModel extends DailyFeedingRecordEntity {
  const DailyFeedingRecordModel({
    required super.date,
    required super.records,
  });

  factory DailyFeedingRecordModel.fromJson(Map<String, dynamic> json) {
    return DailyFeedingRecordModel(
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => FeedingDailyRecordItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class FeedingDailyRecordItemModel extends FeedingDailyRecordItemEntity {
  const FeedingDailyRecordItemModel({
    required super.timesPerDay,
    required super.feedingType,
    required super.status,
  });

  factory FeedingDailyRecordItemModel.fromJson(Map<String, dynamic> json) {
    return FeedingDailyRecordItemModel(
      timesPerDay: json['timesPerDay'] as int? ?? 0,
      feedingType: json['feedingType'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}
