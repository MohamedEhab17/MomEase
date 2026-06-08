import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/sleep_repository.dart';

@injectable
class GetSleepRecordsUseCase {
  final SleepRepository repository;

  GetSleepRecordsUseCase(this.repository);

  Future<Either<Failure, List<SleepRecordEntity>>> call(int childId) {
    return repository.getSleepRecords(childId);
  }
}
