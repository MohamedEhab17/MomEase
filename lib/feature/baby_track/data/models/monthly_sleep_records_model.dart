import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'weekly_sleep_records_model.dart';

class MonthlySleepRecordsModel extends MonthlySleepRecordsEntity {
  const MonthlySleepRecordsModel({
    required super.year,
    required super.month,
    required super.monthName,
    required super.dailySleep,
    required super.monthlyAverageSleep,
    super.monthlyAverageSleepFormatted,
    required super.totalRecords,
    required super.goodDays,
    required super.poorDays,
  });

  factory MonthlySleepRecordsModel.fromJson(Map<String, dynamic> json) {
    return MonthlySleepRecordsModel(
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      monthName: json['monthName'] as String? ?? '',
      dailySleep: (json['dailySleep'] as List<dynamic>?)
              ?.map(
                  (e) => DailySleepRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyAverageSleep:
          json['monthlyAverageSleep'] as String? ?? '00:00:00',
      monthlyAverageSleepFormatted: json['monthlyAverageSleepFormatted'] as String?,
      totalRecords: json['totalRecords'] as int? ?? 0,
      goodDays: json['goodDays'] as int? ?? 0,
      poorDays: json['poorDays'] as int? ?? 0,
    );
  }
}
