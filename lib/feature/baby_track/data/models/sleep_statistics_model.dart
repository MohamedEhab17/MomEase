import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';

class SleepStatisticsModel extends SleepStatisticsEntity {
  const SleepStatisticsModel({
    required super.totalRecords,
    required super.averageSleepHours,
    required super.averageSleepHoursFormatted,
    required super.maxSleepHours,
    required super.minSleepHours,
    required super.goodSleepDays,
    required super.normalSleepDays,
    required super.poorSleepDays,
    required super.last7DaysAverage,
    required super.last7DaysAverageFormatted,
    required super.currentSleepStatus,
    required super.mostCommonStatus,
    required super.comparisonWithReference,
  });

  factory SleepStatisticsModel.fromJson(Map<String, dynamic> json) {
    return SleepStatisticsModel(
      totalRecords: json['totalRecords'] as int? ?? 0,
      averageSleepHours: json['averageSleepHours'] as String? ?? '00:00:00',
      averageSleepHoursFormatted:
          json['averageSleepHoursFormatted'] as String? ?? '0h 0m',
      maxSleepHours: json['maxSleepHours'] as String? ?? '00:00:00',
      minSleepHours: json['minSleepHours'] as String? ?? '00:00:00',
      goodSleepDays: json['goodSleepDays'] as int? ?? 0,
      normalSleepDays: json['normalSleepDays'] as int? ?? 0,
      poorSleepDays: json['poorSleepDays'] as int? ?? 0,
      last7DaysAverage: json['last7DaysAverage'] as String? ?? '00:00:00',
      last7DaysAverageFormatted:
          json['last7DaysAverageFormatted'] as String? ?? '0h 0m',
      currentSleepStatus: json['currentSleepStatus'] as String? ?? 'Unknown',
      mostCommonStatus: json['mostCommonStatus'] as String? ?? 'Unknown',
      comparisonWithReference: SleepComparisonWithReferenceModel.fromJson(
        json['comparisonWithReference'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class SleepComparisonWithReferenceModel extends SleepComparisonWithReferenceEntity {
  const SleepComparisonWithReferenceModel({
    required super.status,
    required super.recommendedMinHours,
    required super.recommendedMaxHours,
    required super.actualAverageHours,
    required super.message,
  });

  factory SleepComparisonWithReferenceModel.fromJson(
      Map<String, dynamic> json) {
    return SleepComparisonWithReferenceModel(
      status: json['status'] as String? ?? '',
      recommendedMinHours: json['recommendedMinHours'] as int? ?? 0,
      recommendedMaxHours: json['recommendedMaxHours'] as int? ?? 0,
      actualAverageHours:
          (json['actualAverageHours'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] as String? ?? '',
    );
  }
}
