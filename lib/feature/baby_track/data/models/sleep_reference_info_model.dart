import 'package:new_mama/feature/baby_track/domain/entities/sleep_reference_info_entity.dart';

class SleepReferenceInfoModel extends SleepReferenceInfoEntity {
  const SleepReferenceInfoModel({
    required super.sleepMinHours,
    required super.sleepMaxHours,
    required super.sleepMinHoursFormatted,
    required super.sleepMaxHoursFormatted,
    required super.ageRange,
  });

  factory SleepReferenceInfoModel.fromJson(Map<String, dynamic> json) {
    return SleepReferenceInfoModel(
      sleepMinHours: _parseDuration(json['sleepMinHours']),
      sleepMaxHours: _parseDuration(json['sleepMaxHours']),
      sleepMinHoursFormatted: json['sleepMinHoursFormatted'] as String? ?? '',
      sleepMaxHoursFormatted: json['sleepMaxHoursFormatted'] as String? ?? '',
      ageRange: json['ageRange'] as String? ?? '',
    );
  }

  static String _parseDuration(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is Map<String, dynamic>) {
      final hours = value['hours'] ?? 0;
      final minutes = value['minutes'] ?? 0;
      final seconds = value['seconds'] ?? 0;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '00:00:00';
  }

  Map<String, dynamic> toJson() {
    return {
      'sleepMinHours': sleepMinHours,
      'sleepMaxHours': sleepMaxHours,
      'sleepMinHoursFormatted': sleepMinHoursFormatted,
      'sleepMaxHoursFormatted': sleepMaxHoursFormatted,
      'ageRange': ageRange,
    };
  }

  SleepReferenceInfoEntity toEntity() {
    return SleepReferenceInfoEntity(
      sleepMinHours: sleepMinHours,
      sleepMaxHours: sleepMaxHours,
      sleepMinHoursFormatted: sleepMinHoursFormatted,
      sleepMaxHoursFormatted: sleepMaxHoursFormatted,
      ageRange: ageRange,
    );
  }
}
