import 'package:dartz/dartz.dart' as dartz;
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_growth_chart_data_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_growth_statistics_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_weekly_growth_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_monthly_growth_records_usecase.dart';
import 'growth_insights_state.dart';

@injectable
class GrowthInsightsCubit extends SafeCubit<GrowthInsightsState> {
  final GetGrowthChartDataUseCase _getGrowthChartDataUseCase;
  final GetGrowthStatisticsUseCase _getGrowthStatisticsUseCase;
  final GetWeeklyGrowthRecordsUseCase _getWeeklyGrowthRecordsUseCase;
  final GetMonthlyGrowthRecordsUseCase _getMonthlyGrowthRecordsUseCase;

  GrowthInsightsCubit(
    this._getGrowthChartDataUseCase,
    this._getGrowthStatisticsUseCase,
    this._getWeeklyGrowthRecordsUseCase,
    this._getMonthlyGrowthRecordsUseCase,
  ) : super(GrowthInsightsInitial());

  Future<void> loadGrowthInsights(int childId) async {
    safeEmit(GrowthInsightsLoading());

    final results = await Future.wait([
      _getGrowthChartDataUseCase(childId),
      _getGrowthStatisticsUseCase(childId),
      _getWeeklyGrowthRecordsUseCase(childId),
      _getMonthlyGrowthRecordsUseCase(childId),
    ]);

    final chartResult = results[0] as dartz.Either<Failure, GrowthChartDataEntity>;
    final statsResult = results[1] as dartz.Either<Failure, GrowthStatisticsEntity>;
    final weeklyResult = results[2] as dartz.Either<Failure, WeeklyGrowthRecordsEntity>;
    final monthlyResult = results[3] as dartz.Either<Failure, MonthlyGrowthRecordsEntity>;

    String? error;
    GrowthChartDataEntity? chartData;
    GrowthStatisticsEntity? statistics;
    WeeklyGrowthRecordsEntity? weekly;
    MonthlyGrowthRecordsEntity? monthly;

    chartResult.fold((f) => error = f.message, (r) => chartData = r);
    statsResult.fold((f) => error = f.message, (r) => statistics = r);
    weeklyResult.fold((f) => error = f.message, (r) => weekly = r);
    monthlyResult.fold((f) => error = f.message, (r) => monthly = r);

    if (error != null || chartData == null || statistics == null || weekly == null || monthly == null) {
      safeEmit(GrowthInsightsError(errorMessage: error ?? "An error occurred"));
      return;
    }

    safeEmit(GrowthInsightsLoaded(
      chartData: chartData!,
      statistics: statistics!,
      weeklyRecords: weekly!,
      monthlyRecords: monthly!,
    ));
  }
}
