import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@injectable
class DeleteGrowthRecordUseCase {
  final GrowthRepository repository;

  DeleteGrowthRecordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int childId,
    required int recordId,
  }) {
    return repository.deleteGrowthRecord(childId, recordId);
  }
}
