import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/vaccination_repository.dart';

@injectable
class GetCompletedVaccinationsUseCase {
  final VaccinationRepository repository;

  GetCompletedVaccinationsUseCase(this.repository);

  Future<Either<Failure, List<VaccineEntity>>> call(int childId) {
    return repository.getCompletedVaccinations(childId);
  }
}
