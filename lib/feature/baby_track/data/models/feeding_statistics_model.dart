import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';

class FeedingStatisticsModel extends FeedingStatisticsEntity {
  const FeedingStatisticsModel({
    required super.totalRecords,
    required super.averageTimesPerDay,
    required super.last7DaysAverage,
    required super.currentFeedingStatus,
    required super.mostCommonFeedingType,
    required super.comparisonWithReference,
  });

  factory FeedingStatisticsModel.fromJson(Map<String, dynamic> json) {
    return FeedingStatisticsModel(
      totalRecords: json['totalRecords'] as int? ?? 0,
      averageTimesPerDay: (json['averageTimesPerDay'] as num?)?.toDouble() ?? 0.0,
      last7DaysAverage: (json['last7DaysAverage'] as num?)?.toDouble() ?? 0.0,
      currentFeedingStatus: json['currentFeedingStatus'] as String? ?? '',
      mostCommonFeedingType: json['mostCommonFeedingType'] as String? ?? '',
      comparisonWithReference: ComparisonWithReferenceModel.fromJson(
        json['comparisonWithReference'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class ComparisonWithReferenceModel extends ComparisonWithReferenceEntity {
  const ComparisonWithReferenceModel({
    required super.status,
    required super.recommendedMin,
    required super.recommendedMax,
    required super.actualAverage,
    required super.message,
  });

  factory ComparisonWithReferenceModel.fromJson(Map<String, dynamic> json) {
    return ComparisonWithReferenceModel(
      status: json['status'] as String? ?? '',
      recommendedMin: json['recommendedMin'] as int? ?? 0,
      recommendedMax: json['recommendedMax'] as int? ?? 0,
      actualAverage: (json['actualAverage'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] as String? ?? '',
    );
  }
}
