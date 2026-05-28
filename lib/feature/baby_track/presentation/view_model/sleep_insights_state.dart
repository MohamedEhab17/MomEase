import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';

abstract class SleepInsightsState extends Equatable {
  const SleepInsightsState();

  @override
  List<Object?> get props => [];
}

class SleepInsightsInitial extends SleepInsightsState {}

class SleepInsightsLoading extends SleepInsightsState {}

class SleepInsightsLoaded extends SleepInsightsState {
  final WeeklySleepRecordsEntity weeklyRecords;
  final MonthlySleepRecordsEntity monthlyRecords;
  final SleepStatisticsEntity statistics;

  const SleepInsightsLoaded({
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.statistics,
  });

  @override
  List<Object?> get props => [weeklyRecords, monthlyRecords, statistics];
}

class SleepInsightsError extends SleepInsightsState {
  final String errorMessage;

  const SleepInsightsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
