import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';

abstract class FeedingInsightsState extends Equatable {
  const FeedingInsightsState();

  @override
  List<Object?> get props => [];
}

class FeedingInsightsInitial extends FeedingInsightsState {}

class FeedingInsightsLoading extends FeedingInsightsState {}

class FeedingInsightsLoaded extends FeedingInsightsState {
  final WeeklyFeedingRecordsEntity weeklyRecords;
  final MonthlyFeedingRecordsEntity monthlyRecords;
  final FeedingStatisticsEntity statistics;

  const FeedingInsightsLoaded({
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.statistics,
  });

  @override
  List<Object?> get props => [weeklyRecords, monthlyRecords, statistics];
}

class FeedingInsightsError extends FeedingInsightsState {
  final String errorMessage;

  const FeedingInsightsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
