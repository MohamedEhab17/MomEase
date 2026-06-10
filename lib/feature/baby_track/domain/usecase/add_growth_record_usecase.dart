import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_growth_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@injectable
class AddGrowthRecordUseCase {
  final GrowthRepository repository;

  AddGrowthRecordUseCase(this.repository);

  Future<Either<Failure, GrowthRecordEntity>> call({
    required int childId,
    required AddGrowthRecordRequestModel request,
  }) {
    return repository.addGrowthRecord(childId, request);
  }
}
