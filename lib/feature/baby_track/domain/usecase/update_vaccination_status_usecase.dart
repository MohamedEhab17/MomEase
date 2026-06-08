import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/vaccination_repository.dart';

@injectable
class UpdateVaccinationStatusUseCase {
  final VaccinationRepository repository;

  UpdateVaccinationStatusUseCase(this.repository);

  Future<Either<Failure, VaccineEntity>> call({
    required int childId,
    required int id,
    required String status,
    DateTime? takenDate,
  }) {
    return repository.updateVaccinationStatus(
      childId,
      id,
      status: status,
      takenDate: takenDate,
    );
  }
}
