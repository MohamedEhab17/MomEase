import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/feeding_repository.dart';

@injectable
class GetFeedingStatisticsUseCase {
  final FeedingRepository repository;

  GetFeedingStatisticsUseCase(this.repository);

  Future<Either<Failure, FeedingStatisticsEntity>> call(int childId) {
    return repository.getFeedingStatistics(childId);
  }
}
