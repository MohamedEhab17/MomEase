import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';

import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';

abstract class FeedingRepository {
  Future<Either<Failure, FeedingRecordEntity>> addFeedingRecord(
    int childId,
    AddFeedingRecordRequestModel request,
  );

  Future<Either<Failure, WeeklyFeedingRecordsEntity>> getWeeklyFeedingRecords(int childId);
  Future<Either<Failure, MonthlyFeedingRecordsEntity>> getMonthlyFeedingRecords(int childId);
  Future<Either<Failure, FeedingStatisticsEntity>> getFeedingStatistics(int childId);
  Future<Either<Failure, List<FeedingRecordEntity>>> getFeedingRecords(int childId);
  Future<Either<Failure, void>> deleteFeedingRecord(int childId, int id);
}
