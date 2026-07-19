import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@injectable
class GetMonthlyGrowthRecordsUseCase {
  final GrowthRepository repository;

  GetMonthlyGrowthRecordsUseCase(this.repository);

  Future<Either<Failure, MonthlyGrowthRecordsEntity>> call(int childId) {
    return repository.getMonthlyGrowthRecords(childId);
  }
}
