import 'package:equatable/equatable.dart';

class VaccineEntity extends Equatable {
  final int childVaccineId;
  final int childId;
  final int scheduleId;
  final String vaccineName;
  final String doseTiming;
  final String diseasePrevented;
  final String dosage;
  final String vaccinationWay;
  final int ageInMonths;
  final DateTime scheduledDate;
  final DateTime? takenDate;
  final String status;

  const VaccineEntity({
    required this.childVaccineId,
    required this.childId,
    required this.scheduleId,
    required this.vaccineName,
    required this.doseTiming,
    required this.diseasePrevented,
    required this.dosage,
    required this.vaccinationWay,
    required this.ageInMonths,
    required this.scheduledDate,
    this.takenDate,
    required this.status,
  });

  VaccineEntity copyWith({
    int? childVaccineId,
    int? childId,
    int? scheduleId,
    String? vaccineName,
    String? doseTiming,
    String? diseasePrevented,
    String? dosage,
    String? vaccinationWay,
    int? ageInMonths,
    DateTime? scheduledDate,
    DateTime? takenDate,
    String? status,
  }) {
    return VaccineEntity(
      childVaccineId: childVaccineId ?? this.childVaccineId,
      childId: childId ?? this.childId,
      scheduleId: scheduleId ?? this.scheduleId,
      vaccineName: vaccineName ?? this.vaccineName,
      doseTiming: doseTiming ?? this.doseTiming,
      diseasePrevented: diseasePrevented ?? this.diseasePrevented,
      dosage: dosage ?? this.dosage,
      vaccinationWay: vaccinationWay ?? this.vaccinationWay,
      ageInMonths: ageInMonths ?? this.ageInMonths,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      takenDate: takenDate ?? this.takenDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        childVaccineId,
        childId,
        scheduleId,
        vaccineName,
        doseTiming,
        diseasePrevented,
        dosage,
        vaccinationWay,
        ageInMonths,
        scheduledDate,
        takenDate,
        status,
      ];
}
