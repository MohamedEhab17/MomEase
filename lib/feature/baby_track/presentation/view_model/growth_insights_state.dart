import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_growth_records_entity.dart';

abstract class GrowthInsightsState extends Equatable {
  const GrowthInsightsState();

  @override
  List<Object?> get props => [];
}

class GrowthInsightsInitial extends GrowthInsightsState {}

class GrowthInsightsLoading extends GrowthInsightsState {}

class GrowthInsightsLoaded extends GrowthInsightsState {
  final GrowthChartDataEntity chartData;
  final GrowthStatisticsEntity statistics;
  final WeeklyGrowthRecordsEntity weeklyRecords;
  final MonthlyGrowthRecordsEntity monthlyRecords;

  const GrowthInsightsLoaded({
    required this.chartData,
    required this.statistics,
    required this.weeklyRecords,
    required this.monthlyRecords,
  });

  @override
  List<Object?> get props => [chartData, statistics, weeklyRecords, monthlyRecords];
}

class GrowthInsightsError extends GrowthInsightsState {
  final String errorMessage;

  const GrowthInsightsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
