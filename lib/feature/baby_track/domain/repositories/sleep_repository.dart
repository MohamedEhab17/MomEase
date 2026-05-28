import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';

abstract class SleepRepository {
  Future<Either<Failure, SleepRecordEntity>> addSleepRecord(
    int childId,
    AddSleepRecordRequestModel request,
  );

  Future<Either<Failure, WeeklySleepRecordsEntity>> getWeeklySleepRecords(
      int childId);
  Future<Either<Failure, MonthlySleepRecordsEntity>> getMonthlySleepRecords(
      int childId);
  Future<Either<Failure, SleepStatisticsEntity>> getSleepStatistics(
      int childId);
}
