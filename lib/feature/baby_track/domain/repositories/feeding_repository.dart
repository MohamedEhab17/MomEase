import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';

abstract class FeedingRepository {
  Future<Either<Failure, FeedingRecordEntity>> addFeedingRecord(
    int childId,
    AddFeedingRecordRequestModel request,
  );
}
