import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';

class GrowthStatisticsModel extends GrowthStatisticsEntity {
  const GrowthStatisticsModel({
    required super.totalRecords,
    required super.averageWeight,
    required super.maxWeight,
    required super.minWeight,
    required super.weightGainTotal,
    required super.monthlyWeightGainAverage,
    required super.averageHeight,
    required super.maxHeight,
    required super.minHeight,
    required super.heightGainTotal,
    required super.monthlyHeightGainAverage,
    required super.currentGrowthStatus,
    required super.weightTrend,
    required super.heightTrend,
    super.percentileComparison,
  });

  factory GrowthStatisticsModel.fromJson(Map<String, dynamic> json) {
    return GrowthStatisticsModel(
      totalRecords: json['totalRecords'] as int? ?? 0,
      averageWeight: (json['averageWeight'] as num?)?.toDouble() ?? 0.0,
      maxWeight: (json['maxWeight'] as num?)?.toDouble() ?? 0.0,
      minWeight: (json['minWeight'] as num?)?.toDouble() ?? 0.0,
      weightGainTotal: (json['weightGainTotal'] as num?)?.toDouble() ?? 0.0,
      monthlyWeightGainAverage: (json['monthlyWeightGainAverage'] as num?)?.toDouble() ?? 0.0,
      averageHeight: (json['averageHeight'] as num?)?.toDouble() ?? 0.0,
      maxHeight: (json['maxHeight'] as num?)?.toDouble() ?? 0.0,
      minHeight: (json['minHeight'] as num?)?.toDouble() ?? 0.0,
      heightGainTotal: (json['heightGainTotal'] as num?)?.toDouble() ?? 0.0,
      monthlyHeightGainAverage: (json['monthlyHeightGainAverage'] as num?)?.toDouble() ?? 0.0,
      currentGrowthStatus: json['currentGrowthStatus'] as String? ?? 'Normal',
      weightTrend: json['weightTrend'] as String? ?? 'Increasing',
      heightTrend: json['heightTrend'] as String? ?? 'Increasing',
      percentileComparison: json['percentileComparison'],
    );
  }
}
