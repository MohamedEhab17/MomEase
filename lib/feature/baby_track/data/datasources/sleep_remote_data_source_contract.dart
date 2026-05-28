import 'package:new_mama/feature/baby_track/data/models/sleep_record_model.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/data/models/weekly_sleep_records_model.dart';
import 'package:new_mama/feature/baby_track/data/models/monthly_sleep_records_model.dart';
import 'package:new_mama/feature/baby_track/data/models/sleep_statistics_model.dart';

abstract class SleepRemoteDataSourceContract {
  Future<SleepRecordModel> addSleepRecord(
    int childId,
    AddSleepRecordRequestModel body,
  );

  Future<WeeklySleepRecordsModel> getWeeklySleepRecords(int childId);
  Future<MonthlySleepRecordsModel> getMonthlySleepRecords(int childId);
  Future<SleepStatisticsModel> getSleepStatistics(int childId);
}
