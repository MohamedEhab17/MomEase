import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/sleep_repository.dart';

@injectable
class DeleteSleepRecordUseCase {
  final SleepRepository repository;

  DeleteSleepRecordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int childId,
    required int recordId,
  }) {
    return repository.deleteSleepRecord(childId, recordId);
  }
}
