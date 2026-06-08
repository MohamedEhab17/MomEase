import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/feeding_repository.dart';

@injectable
class GetWeeklyFeedingRecordsUseCase {
  final FeedingRepository repository;

  GetWeeklyFeedingRecordsUseCase(this.repository);

  Future<Either<Failure, WeeklyFeedingRecordsEntity>> call(int childId) {
    return repository.getWeeklyFeedingRecords(childId);
  }
}
