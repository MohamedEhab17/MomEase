import 'package:new_mama/feature/baby_track/domain/entities/growth_record_entity.dart';

class GrowthRecordModel extends GrowthRecordEntity {
  const GrowthRecordModel({
    required super.growthId,
    required super.childName,
    required super.recordDate,
    required super.ageInWeeks,
    required super.ageInMonths,
    required super.weightKg,
    required super.heightCm,
  });

  factory GrowthRecordModel.fromJson(Map<String, dynamic> json) {
    return GrowthRecordModel(
      growthId: json['growthId'] as int? ?? 0,
      childName: json['childName'] as String? ?? '',
      recordDate: json['recordDate'] != null
          ? DateTime.parse(json['recordDate'] as String)
          : DateTime.now(),
      ageInWeeks: json['ageInWeeks'] as int? ?? 0,
      ageInMonths: json['ageInMonths'] as int? ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'growthId': growthId,
      'childName': childName,
      'recordDate': recordDate.toIso8601String(),
      'ageInWeeks': ageInWeeks,
      'ageInMonths': ageInMonths,
      'weightKg': weightKg,
      'heightCm': heightCm,
    };
  }

  GrowthRecordEntity toEntity() {
    return GrowthRecordEntity(
      growthId: growthId,
      childName: childName,
      recordDate: recordDate,
      ageInWeeks: ageInWeeks,
      ageInMonths: ageInMonths,
      weightKg: weightKg,
      heightCm: heightCm,
    );
  }
}
