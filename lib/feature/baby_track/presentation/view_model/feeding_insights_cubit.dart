import 'package:dartz/dartz.dart' as dartz;
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_weekly_feeding_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_monthly_feeding_records_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_feeding_statistics_usecase.dart';
import 'feeding_insights_state.dart';

@injectable
class FeedingInsightsCubit extends SafeCubit<FeedingInsightsState> {
  final GetWeeklyFeedingRecordsUseCase _getWeeklyFeedingRecordsUseCase;
  final GetMonthlyFeedingRecordsUseCase _getMonthlyFeedingRecordsUseCase;
  final GetFeedingStatisticsUseCase _getFeedingStatisticsUseCase;

  FeedingInsightsCubit(
    this._getWeeklyFeedingRecordsUseCase,
    this._getMonthlyFeedingRecordsUseCase,
    this._getFeedingStatisticsUseCase,
  ) : super(FeedingInsightsInitial());

  Future<void> loadFeedingInsights(int childId) async {
    safeEmit(FeedingInsightsLoading());

    final results = await Future.wait([
      _getWeeklyFeedingRecordsUseCase(childId),
      _getMonthlyFeedingRecordsUseCase(childId),
      _getFeedingStatisticsUseCase(childId),
    ]);

    final weeklyResult = results[0] as dartz.Either<Failure, WeeklyFeedingRecordsEntity>;
    final monthlyResult = results[1] as dartz.Either<Failure, MonthlyFeedingRecordsEntity>;
    final statsResult = results[2] as dartz.Either<Failure, FeedingStatisticsEntity>;

    String? error;
    WeeklyFeedingRecordsEntity? weekly;
    MonthlyFeedingRecordsEntity? monthly;
    FeedingStatisticsEntity? stats;

    weeklyResult.fold((f) => error = f.message, (r) => weekly = r);
    monthlyResult.fold((f) => error = f.message, (r) => monthly = r);
    statsResult.fold((f) => error = f.message, (r) => stats = r);

    if (error != null || weekly == null || monthly == null || stats == null) {
      safeEmit(FeedingInsightsError(errorMessage: error ?? "An error occurred"));
      return;
    }

    safeEmit(FeedingInsightsLoaded(
      weeklyRecords: weekly!,
      monthlyRecords: monthly!,
      statistics: stats!,
    ));
  }
}
