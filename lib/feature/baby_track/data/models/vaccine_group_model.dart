import 'package:new_mama/feature/baby_track/data/models/vaccine_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_group_entity.dart';

class VaccineGroupModel extends VaccineGroupEntity {
  final List<VaccineModel> vaccinesModel;

  const VaccineGroupModel({
    required super.ageInMonths,
    required super.ageLabel,
    required super.scheduledDate,
    required this.vaccinesModel,
  }) : super(vaccines: vaccinesModel);

  factory VaccineGroupModel.fromJson(Map<String, dynamic> json) {
    return VaccineGroupModel(
      ageInMonths: json['ageInMonths'] as int? ?? 0,
      ageLabel: json['ageLabel'] as String? ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : DateTime.now(),
      vaccinesModel: (json['vaccines'] as List?)
              ?.map((v) => VaccineModel.fromJson(v as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ageInMonths': ageInMonths,
      'ageLabel': ageLabel,
      'scheduledDate': scheduledDate.toIso8601String(),
      'vaccines': vaccinesModel.map((v) => v.toJson()).toList(),
    };
  }

  VaccineGroupEntity toEntity() {
    return VaccineGroupEntity(
      ageInMonths: ageInMonths,
      ageLabel: ageLabel,
      scheduledDate: scheduledDate,
      vaccines: vaccinesModel.map((v) => v.toEntity()).toList(),
    );
  }
}
