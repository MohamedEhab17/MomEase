import 'package:new_mama/feature/baby_track/data/models/sleep_record_model.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';

abstract class SleepRemoteDataSourceContract {
  Future<SleepRecordModel> addSleepRecord(
    int childId,
    AddSleepRecordRequestModel body,
  );
}
