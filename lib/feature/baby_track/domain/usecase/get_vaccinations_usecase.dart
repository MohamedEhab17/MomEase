import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_group_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/vaccination_repository.dart';

@injectable
class GetVaccinationsUseCase {
  final VaccinationRepository repository;

  GetVaccinationsUseCase(this.repository);

  Future<Either<Failure, List<VaccineGroupEntity>>> call(int childId) {
    return repository.getVaccinations(childId);
  }
}
