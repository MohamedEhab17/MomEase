import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'weekly_feeding_records_model.dart';

class MonthlyFeedingRecordsModel extends MonthlyFeedingRecordsEntity {
  const MonthlyFeedingRecordsModel({
    required super.year,
    required super.month,
    required super.monthName,
    required super.dailyRecords,
    required super.monthlyAverageTimesPerDay,
    required super.totalRecords,
    required super.normalDays,
    required super.abnormalDays,
  });

  factory MonthlyFeedingRecordsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyFeedingRecordsModel(
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      monthName: json['monthName'] as String? ?? '',
      dailyRecords: (json['dailyRecords'] as List<dynamic>?)
              ?.map((e) => DailyFeedingRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyAverageTimesPerDay:
          (json['monthlyAverageTimesPerDay'] as num?)?.toDouble() ?? 0.0,
      totalRecords: json['totalRecords'] as int? ?? 0,
      normalDays: json['normalDays'] as int? ?? 0,
      abnormalDays: json['abnormalDays'] as int? ?? 0,
    );
  }
}
