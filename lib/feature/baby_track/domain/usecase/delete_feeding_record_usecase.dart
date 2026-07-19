import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/feeding_repository.dart';

@injectable
class DeleteFeedingRecordUseCase {
  final FeedingRepository repository;

  DeleteFeedingRecordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int childId,
    required int recordId,
  }) {
    return repository.deleteFeedingRecord(childId, recordId);
  }
}
