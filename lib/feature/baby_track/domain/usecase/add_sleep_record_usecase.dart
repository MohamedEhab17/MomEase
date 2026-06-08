import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/sleep_repository.dart';

@injectable
class AddSleepRecordUseCase {
  final SleepRepository repository;

  AddSleepRecordUseCase(this.repository);

  Future<Either<Failure, SleepRecordEntity>> call({
    required int childId,
    required AddSleepRecordRequestModel request,
  }) {
    return repository.addSleepRecord(childId, request);
  }
}
