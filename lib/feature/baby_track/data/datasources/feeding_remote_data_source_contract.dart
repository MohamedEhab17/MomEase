import 'package:new_mama/feature/baby_track/data/models/feeding_record_model.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';
import 'package:new_mama/feature/baby_track/data/models/weekly_feeding_records_model.dart';
import 'package:new_mama/feature/baby_track/data/models/monthly_feeding_records_model.dart';
import 'package:new_mama/feature/baby_track/data/models/feeding_statistics_model.dart';

abstract class FeedingRemoteDataSourceContract {
  Future<FeedingRecordModel> addFeedingRecord(
    int childId,
    AddFeedingRecordRequestModel body,
  );

  Future<WeeklyFeedingRecordsModel> getWeeklyFeedingRecords(int childId);
  Future<MonthlyFeedingRecordsModel> getMonthlyFeedingRecords(int childId);
  Future<FeedingStatisticsModel> getFeedingStatistics(int childId);
  Future<List<FeedingRecordModel>> getFeedingRecords(int childId);
  Future<void> deleteFeedingRecord(int childId, int id);
}
