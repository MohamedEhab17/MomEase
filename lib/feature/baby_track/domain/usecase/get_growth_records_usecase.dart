import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@injectable
class GetGrowthRecordsUseCase {
  final GrowthRepository repository;

  GetGrowthRecordsUseCase(this.repository);

  Future<Either<Failure, List<GrowthRecordEntity>>> call(int childId) {
    return repository.getGrowthRecords(childId);
  }
}
