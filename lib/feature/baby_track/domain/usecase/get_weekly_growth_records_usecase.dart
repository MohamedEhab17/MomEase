import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@injectable
class GetWeeklyGrowthRecordsUseCase {
  final GrowthRepository repository;

  GetWeeklyGrowthRecordsUseCase(this.repository);

  Future<Either<Failure, WeeklyGrowthRecordsEntity>> call(int childId) {
    return repository.getWeeklyGrowthRecords(childId);
  }
}
