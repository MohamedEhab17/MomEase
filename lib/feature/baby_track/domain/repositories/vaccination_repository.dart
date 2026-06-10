import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_group_entity.dart';

abstract class VaccinationRepository {
  Future<Either<Failure, List<VaccineGroupEntity>>> getVaccinations(int childId);
  Future<Either<Failure, VaccineEntity>> getVaccinationById(int childId, int id);
  Future<Either<Failure, VaccineEntity>> updateVaccinationStatus(
    int childId,
    int id, {
    required String status,
    DateTime? takenDate,
  });
  Future<Either<Failure, List<VaccineEntity>>> getUpcomingVaccinations(int childId, int daysAhead);
  Future<Either<Failure, List<VaccineEntity>>> getOverdueVaccinations(int childId);
  Future<Either<Failure, List<VaccineEntity>>> getCompletedVaccinations(int childId);
  Future<Either<Failure, VaccineEntity>> markVaccinationAsTaken(
    int childId,
    int id, {
    required String status,
    DateTime? takenDate,
  });
}
