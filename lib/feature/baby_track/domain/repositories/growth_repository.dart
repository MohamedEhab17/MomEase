import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_growth_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_growth_records_entity.dart';

abstract class GrowthRepository {
  Future<Either<Failure, GrowthRecordEntity>> addGrowthRecord(
    int childId,
    AddGrowthRecordRequestModel request,
  );

  Future<Either<Failure, List<GrowthRecordEntity>>> getGrowthRecords(int childId);
  Future<Either<Failure, void>> deleteGrowthRecord(int childId, int id);
  Future<Either<Failure, GrowthChartDataEntity>> getGrowthChartData(int childId);
  Future<Either<Failure, GrowthStatisticsEntity>> getGrowthStatistics(int childId);
  Future<Either<Failure, WeeklyGrowthRecordsEntity>> getWeeklyGrowthRecords(int childId);
  Future<Either<Failure, MonthlyGrowthRecordsEntity>> getMonthlyGrowthRecords(int childId);
}
