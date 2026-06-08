import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@injectable
class GetGrowthStatisticsUseCase {
  final GrowthRepository repository;

  GetGrowthStatisticsUseCase(this.repository);

  Future<Either<Failure, GrowthStatisticsEntity>> call(int childId) {
    return repository.getGrowthStatistics(childId);
  }
}
