import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/feeding_repository.dart';

@injectable
class AddFeedingRecordUseCase {
  final FeedingRepository repository;

  AddFeedingRecordUseCase(this.repository);

  Future<Either<Failure, FeedingRecordEntity>> call({
    required int childId,
    required AddFeedingRecordRequestModel request,
  }) {
    return repository.addFeedingRecord(childId, request);
  }
}
