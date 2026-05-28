import 'package:equatable/equatable.dart';

class SleepStatisticsEntity extends Equatable {
  final int totalRecords;
  final String averageSleepHours;
  final String averageSleepHoursFormatted;
  final String maxSleepHours;
  final String minSleepHours;
  final int goodSleepDays;
  final int normalSleepDays;
  final int poorSleepDays;
  final double sleepQualityPercentage;
  final String last7DaysAverage;
  final String last7DaysAverageFormatted;
  final String currentSleepStatus;
  final String mostCommonStatus;
  final SleepComparisonWithReferenceEntity comparisonWithReference;

  const SleepStatisticsEntity({
    required this.totalRecords,
    required this.averageSleepHours,
    required this.averageSleepHoursFormatted,
    required this.maxSleepHours,
    required this.minSleepHours,
    required this.goodSleepDays,
    required this.normalSleepDays,
    required this.poorSleepDays,
    required this.sleepQualityPercentage,
    required this.last7DaysAverage,
    required this.last7DaysAverageFormatted,
    required this.currentSleepStatus,
    required this.mostCommonStatus,
    required this.comparisonWithReference,
  });

  @override
  List<Object?> get props => [
        totalRecords,
        averageSleepHours,
        averageSleepHoursFormatted,
        maxSleepHours,
        minSleepHours,
        goodSleepDays,
        normalSleepDays,
        poorSleepDays,
        sleepQualityPercentage,
        last7DaysAverage,
        last7DaysAverageFormatted,
        currentSleepStatus,
        mostCommonStatus,
        comparisonWithReference,
      ];
}

class SleepComparisonWithReferenceEntity extends Equatable {
  final String status;
  final int recommendedMinHours;
  final int recommendedMaxHours;
  final double actualAverageHours;
  final String message;

  const SleepComparisonWithReferenceEntity({
    required this.status,
    required this.recommendedMinHours,
    required this.recommendedMaxHours,
    required this.actualAverageHours,
    required this.message,
  });

  @override
  List<Object?> get props => [
        status,
        recommendedMinHours,
        recommendedMaxHours,
        actualAverageHours,
        message,
      ];
}
