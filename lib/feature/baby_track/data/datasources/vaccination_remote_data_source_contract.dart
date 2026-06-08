import 'package:new_mama/feature/baby_track/data/models/vaccine_model.dart';
import 'package:new_mama/feature/baby_track/data/models/vaccine_group_model.dart';
import 'package:new_mama/feature/baby_track/data/models/update_vaccination_request_model.dart';

abstract class VaccinationRemoteDataSourceContract {
  Future<List<VaccineGroupModel>> getVaccinations(int childId);
  Future<VaccineModel> getVaccinationById(int childId, int id);
  Future<VaccineModel> updateVaccinationStatus(
    int childId,
    int id,
    UpdateVaccinationRequestModel body,
  );
  Future<List<VaccineModel>> getUpcomingVaccinations(int childId, int daysAhead);
  Future<List<VaccineModel>> getOverdueVaccinations(int childId);
  Future<List<VaccineModel>> getCompletedVaccinations(int childId);
  Future<VaccineModel> markVaccinationAsTaken(
    int childId,
    int id,
    UpdateVaccinationRequestModel body,
  );
}
