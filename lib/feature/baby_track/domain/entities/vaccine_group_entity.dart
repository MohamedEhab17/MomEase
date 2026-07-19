import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';

class VaccineGroupEntity extends Equatable {
  final int ageInMonths;
  final String ageLabel;
  final DateTime scheduledDate;
  final List<VaccineEntity> vaccines;

  const VaccineGroupEntity({
    required this.ageInMonths,
    required this.ageLabel,
    required this.scheduledDate,
    required this.vaccines,
  });

  VaccineGroupEntity copyWith({
    int? ageInMonths,
    String? ageLabel,
    DateTime? scheduledDate,
    List<VaccineEntity>? vaccines,
  }) {
    return VaccineGroupEntity(
      ageInMonths: ageInMonths ?? this.ageInMonths,
      ageLabel: ageLabel ?? this.ageLabel,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      vaccines: vaccines ?? this.vaccines,
    );
  }

  @override
  List<Object?> get props => [
        ageInMonths,
        ageLabel,
        scheduledDate,
        vaccines,
      ];
}
