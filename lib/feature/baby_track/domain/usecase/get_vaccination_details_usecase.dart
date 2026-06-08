import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/vaccination_repository.dart';

@injectable
class GetVaccinationDetailsUseCase {
  final VaccinationRepository repository;

  GetVaccinationDetailsUseCase(this.repository);

  Future<Either<Failure, VaccineEntity>> call(int childId, int id) {
    return repository.getVaccinationById(childId, id);
  }
}
