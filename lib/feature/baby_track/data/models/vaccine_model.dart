import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';

class VaccineModel extends VaccineEntity {
  const VaccineModel({
    required super.childVaccineId,
    required super.childId,
    required super.scheduleId,
    required super.vaccineName,
    required super.doseTiming,
    required super.diseasePrevented,
    required super.dosage,
    required super.vaccinationWay,
    required super.ageInMonths,
    required super.scheduledDate,
    super.takenDate,
    required super.status,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      childVaccineId: json['childVaccineId'] as int? ?? 0,
      childId: json['childId'] as int? ?? 0,
      scheduleId: json['scheduleId'] as int? ?? 0,
      vaccineName: json['vaccineName'] as String? ?? '',
      doseTiming: json['doseTiming'] as String? ?? '',
      diseasePrevented: json['diseasePrevented'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      vaccinationWay: json['vaccinationWay'] as String? ?? '',
      ageInMonths: json['ageInMonths'] as int? ?? 0,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : DateTime.now(),
      takenDate: json['takenDate'] != null
          ? DateTime.parse(json['takenDate'] as String)
          : null,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childVaccineId': childVaccineId,
      'childId': childId,
      'scheduleId': scheduleId,
      'vaccineName': vaccineName,
      'doseTiming': doseTiming,
      'diseasePrevented': diseasePrevented,
      'dosage': dosage,
      'vaccinationWay': vaccinationWay,
      'ageInMonths': ageInMonths,
      'scheduledDate': scheduledDate.toIso8601String(),
      'takenDate': takenDate?.toIso8601String(),
      'status': status,
    };
  }

  VaccineEntity toEntity() {
    return VaccineEntity(
      childVaccineId: childVaccineId,
      childId: childId,
      scheduleId: scheduleId,
      vaccineName: vaccineName,
      doseTiming: doseTiming,
      diseasePrevented: diseasePrevented,
      dosage: dosage,
      vaccinationWay: vaccinationWay,
      ageInMonths: ageInMonths,
      scheduledDate: scheduledDate,
      takenDate: takenDate,
      status: status,
    );
  }
}
