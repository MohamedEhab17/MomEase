import 'package:equatable/equatable.dart';

class GrowthStatisticsEntity extends Equatable {
  final int totalRecords;
  final double averageWeight;
  final double maxWeight;
  final double minWeight;
  final double weightGainTotal;
  final double monthlyWeightGainAverage;
  final double averageHeight;
  final double maxHeight;
  final double minHeight;
  final double heightGainTotal;
  final double monthlyHeightGainAverage;
  final String currentGrowthStatus;
  final String weightTrend;
  final String heightTrend;
  final dynamic percentileComparison;

  const GrowthStatisticsEntity({
    required this.totalRecords,
    required this.averageWeight,
    required this.maxWeight,
    required this.minWeight,
    required this.weightGainTotal,
    required this.monthlyWeightGainAverage,
    required this.averageHeight,
    required this.maxHeight,
    required this.minHeight,
    required this.heightGainTotal,
    required this.monthlyHeightGainAverage,
    required this.currentGrowthStatus,
    required this.weightTrend,
    required this.heightTrend,
    this.percentileComparison,
  });

  @override
  List<Object?> get props => [
        totalRecords,
        averageWeight,
        maxWeight,
        minWeight,
        weightGainTotal,
        monthlyWeightGainAverage,
        averageHeight,
        maxHeight,
        minHeight,
        heightGainTotal,
        monthlyHeightGainAverage,
        currentGrowthStatus,
        weightTrend,
        heightTrend,
        percentileComparison,
      ];
}
