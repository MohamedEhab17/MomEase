import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/sleep_repository.dart';

@injectable
class GetWeeklySleepRecordsUseCase {
  final SleepRepository repository;

  GetWeeklySleepRecordsUseCase(this.repository);

  Future<Either<Failure, WeeklySleepRecordsEntity>> call(int childId) {
    return repository.getWeeklySleepRecords(childId);
  }
}
