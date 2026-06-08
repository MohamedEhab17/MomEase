import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/sleep_repository.dart';

@injectable
class GetSleepStatisticsUseCase {
  final SleepRepository repository;

  GetSleepStatisticsUseCase(this.repository);

  Future<Either<Failure, SleepStatisticsEntity>> call(int childId) {
    return repository.getSleepStatistics(childId);
  }
}
