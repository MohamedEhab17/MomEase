import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';

abstract class SleepRepository {
  Future<Either<Failure, SleepRecordEntity>> addSleepRecord(
    int childId,
    AddSleepRecordRequestModel request,
  );
}
