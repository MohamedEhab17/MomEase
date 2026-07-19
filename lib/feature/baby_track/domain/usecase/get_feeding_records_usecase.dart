import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/feeding_repository.dart';

@injectable
class GetFeedingRecordsUseCase {
  final FeedingRepository repository;

  GetFeedingRecordsUseCase(this.repository);

  Future<Either<Failure, List<FeedingRecordEntity>>> call(int childId) {
    return repository.getFeedingRecords(childId);
  }
}
