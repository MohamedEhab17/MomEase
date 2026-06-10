import 'package:dartz/dartz.dart' as dartz;
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_weekly_sleep_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_monthly_sleep_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_sleep_statistics_usecase.dart';
import 'sleep_insights_state.dart';

@injectable
class SleepInsightsCubit extends SafeCubit<SleepInsightsState> {
  final GetWeeklySleepRecordsUseCase _getWeeklySleepRecordsUseCase;
  final GetMonthlySleepRecordsUseCase _getMonthlySleepRecordsUseCase;
  final GetSleepStatisticsUseCase _getSleepStatisticsUseCase;

  SleepInsightsCubit(
    this._getWeeklySleepRecordsUseCase,
    this._getMonthlySleepRecordsUseCase,
    this._getSleepStatisticsUseCase,
  ) : super(SleepInsightsInitial());

  Future<void> loadSleepInsights(int childId) async {
    safeEmit(SleepInsightsLoading());

    final results = await Future.wait([
      _getWeeklySleepRecordsUseCase(childId),
      _getMonthlySleepRecordsUseCase(childId),
      _getSleepStatisticsUseCase(childId),
    ]);

    final weeklyResult =
        results[0] as dartz.Either<Failure, WeeklySleepRecordsEntity>;
    final monthlyResult =
        results[1] as dartz.Either<Failure, MonthlySleepRecordsEntity>;
    final statsResult =
        results[2] as dartz.Either<Failure, SleepStatisticsEntity>;

    String? error;
    WeeklySleepRecordsEntity? weekly;
    MonthlySleepRecordsEntity? monthly;
    SleepStatisticsEntity? stats;

    weeklyResult.fold((f) => error = f.message, (r) => weekly = r);
    monthlyResult.fold((f) => error = f.message, (r) => monthly = r);
    statsResult.fold((f) => error = f.message, (r) => stats = r);

    if (error != null || weekly == null || monthly == null || stats == null) {
      safeEmit(
          SleepInsightsError(errorMessage: error ?? 'An error occurred'));
      return;
    }

    safeEmit(SleepInsightsLoaded(
      weeklyRecords: weekly!,
      monthlyRecords: monthly!,
      statistics: stats!,
    ));
  }
}
