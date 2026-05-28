import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/sleep_repository.dart';

@injectable
class GetMonthlySleepRecordsUseCase {
  final SleepRepository repository;

  GetMonthlySleepRecordsUseCase(this.repository);

  Future<Either<Failure, MonthlySleepRecordsEntity>> call(int childId) {
    return repository.getMonthlySleepRecords(childId);
  }
}
