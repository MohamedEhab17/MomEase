import 'package:new_mama/feature/baby_track/domain/entities/monthly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/data/models/weekly_growth_records_model.dart';

class MonthlyGrowthRecordsModel extends MonthlyGrowthRecordsEntity {
  const MonthlyGrowthRecordsModel({
    required super.year,
    required super.month,
    required super.monthName,
    required super.dailyGrowth,
    required super.monthlyWeightGain,
    required super.monthlyHeightGain,
    required super.totalRecords,
    required super.goodGrowthDays,
    required super.poorGrowthDays,
  });

  factory MonthlyGrowthRecordsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyGrowthRecordsModel(
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      monthName: json['monthName'] as String? ?? '',
      dailyGrowth: (json['dailyGrowth'] as List<dynamic>?)
              ?.map((e) => DailyGrowthModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyWeightGain: (json['monthlyWeightGain'] as num?)?.toDouble() ?? 0.0,
      monthlyHeightGain: (json['monthlyHeightGain'] as num?)?.toDouble() ?? 0.0,
      totalRecords: json['totalRecords'] as int? ?? 0,
      goodGrowthDays: json['goodGrowthDays'] as int? ?? 0,
      poorGrowthDays: json['poorGrowthDays'] as int? ?? 0,
    );
  }
}
