import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/feeding_repository.dart';

@injectable
class GetMonthlyFeedingRecordsUseCase {
  final FeedingRepository repository;

  GetMonthlyFeedingRecordsUseCase(this.repository);

  Future<Either<Failure, MonthlyFeedingRecordsEntity>> call(int childId) {
    return repository.getMonthlyFeedingRecords(childId);
  }
}
