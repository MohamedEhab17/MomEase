import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';

class DailyGrowthModel extends DailyGrowthEntity {
  const DailyGrowthModel({
    required super.date,
    super.weight,
    super.height,
    required super.status,
  });

  factory DailyGrowthModel.fromJson(Map<String, dynamic> json) {
    return DailyGrowthModel(
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'Normal',
    );
  }
}

class WeeklyGrowthRecordsModel extends WeeklyGrowthRecordsEntity {
  const WeeklyGrowthRecordsModel({
    required super.weekStart,
    required super.weekEnd,
    required super.dailyGrowth,
    required super.weeklyWeightGain,
    required super.weeklyHeightGain,
    required super.totalRecords,
  });

  factory WeeklyGrowthRecordsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyGrowthRecordsModel(
      weekStart: json['weekStart'] != null ? DateTime.parse(json['weekStart'] as String) : DateTime.now(),
      weekEnd: json['weekEnd'] != null ? DateTime.parse(json['weekEnd'] as String) : DateTime.now(),
      dailyGrowth: (json['dailyGrowth'] as List<dynamic>?)
              ?.map((e) => DailyGrowthModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weeklyWeightGain: (json['weeklyWeightGain'] as num?)?.toDouble() ?? 0.0,
      weeklyHeightGain: (json['weeklyHeightGain'] as num?)?.toDouble() ?? 0.0,
      totalRecords: json['totalRecords'] as int? ?? 0,
    );
  }
}
