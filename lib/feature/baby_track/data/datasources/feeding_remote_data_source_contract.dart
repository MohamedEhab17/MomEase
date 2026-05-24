import 'package:new_mama/feature/baby_track/data/models/feeding_record_model.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';

abstract class FeedingRemoteDataSourceContract {
  Future<FeedingRecordModel> addFeedingRecord(
    int childId,
    AddFeedingRecordRequestModel body,
  );
}
