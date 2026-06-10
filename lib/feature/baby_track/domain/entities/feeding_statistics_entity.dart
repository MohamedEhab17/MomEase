import 'package:equatable/equatable.dart';

class FeedingStatisticsEntity extends Equatable {
  final int totalRecords;
  final double averageTimesPerDay;
  final double last7DaysAverage;
  final String currentFeedingStatus;
  final String mostCommonFeedingType;
  final ComparisonWithReferenceEntity comparisonWithReference;

  const FeedingStatisticsEntity({
    required this.totalRecords,
    required this.averageTimesPerDay,
    required this.last7DaysAverage,
    required this.currentFeedingStatus,
    required this.mostCommonFeedingType,
    required this.comparisonWithReference,
  });

  @override
  List<Object?> get props => [
        totalRecords,
        averageTimesPerDay,
        last7DaysAverage,
        currentFeedingStatus,
        mostCommonFeedingType,
        comparisonWithReference,
      ];
}

class ComparisonWithReferenceEntity extends Equatable {
  final String status;
  final int recommendedMin;
  final int recommendedMax;
  final double actualAverage;
  final String message;

  const ComparisonWithReferenceEntity({
    required this.status,
    required this.recommendedMin,
    required this.recommendedMax,
    required this.actualAverage,
    required this.message,
  });

  @override
  List<Object?> get props => [
        status,
        recommendedMin,
        recommendedMax,
        actualAverage,
        message,
      ];
}
