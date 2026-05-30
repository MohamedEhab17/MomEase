import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';

class WeeklySleepRecordsModel extends WeeklySleepRecordsEntity {
  const WeeklySleepRecordsModel({
    required super.weekStart,
    required super.weekEnd,
    required super.dailySleep,
    required super.weeklyAverageSleep,
    super.weeklyAverageSleepFormatted,
    required super.totalRecords,
    super.totalSessions,
  });

  factory WeeklySleepRecordsModel.fromJson(Map<String, dynamic> json) {
    return WeeklySleepRecordsModel(
      weekStart: json['weekStart'] != null
          ? DateTime.parse(json['weekStart'] as String)
          : DateTime.now(),
      weekEnd: json['weekEnd'] != null
          ? DateTime.parse(json['weekEnd'] as String)
          : DateTime.now(),
      dailySleep: (json['dailySleep'] as List<dynamic>?)
              ?.map(
                  (e) => DailySleepRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weeklyAverageSleep: json['weeklyAverageSleep'] as String? ?? '00:00:00',
      weeklyAverageSleepFormatted: json['weeklyAverageSleepFormatted'] as String?,
      totalRecords: json['totalRecords'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int?,
    );
  }
}

class DailySleepRecordModel extends DailySleepRecordEntity {
  const DailySleepRecordModel({
    required super.date,
    required super.sleepHours,
    super.sleepHoursFormatted,
    required super.status,
    super.sessionCount,
  });

  factory DailySleepRecordModel.fromJson(Map<String, dynamic> json) {
    return DailySleepRecordModel(
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      sleepHours: json['sleepHours'] as String?,
      sleepHoursFormatted: json['sleepHoursFormatted'] as String?,
      status: json['status'] as String? ?? 'Unknown',
      sessionCount: json['sessionCount'] as int?,
    );
  }
}
