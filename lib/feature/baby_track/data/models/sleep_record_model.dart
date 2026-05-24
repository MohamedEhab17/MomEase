import 'package:new_mama/feature/baby_track/data/models/sleep_reference_info_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';

class SleepRecordModel extends SleepRecordEntity {
  const SleepRecordModel({
    required super.recordId,
    required super.childId,
    required super.childName,
    required super.sleepDate,
    required super.sleepHoursTotal,
    required super.sleepHoursTotalFormatted,
    super.sleepRefId,
    required super.notes,
    required super.status,
    super.referenceInfo,
  });

  factory SleepRecordModel.fromJson(Map<String, dynamic> json) {
    return SleepRecordModel(
      recordId: json['recordId'] as int? ?? 0,
      childId: json['childId'] as int? ?? 0,
      childName: json['childName'] as String? ?? '',
      sleepDate: json['sleepDate'] != null
          ? DateTime.parse(json['sleepDate'] as String)
          : DateTime.now(),
      sleepHoursTotal: _parseDuration(json['sleepHoursTotal']),
      sleepHoursTotalFormatted: json['sleepHoursTotalFormatted'] as String? ?? '',
      sleepRefId: json['sleepRefId'] as int?,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? '',
      referenceInfo: json['referenceInfo'] != null
          ? SleepReferenceInfoModel.fromJson(json['referenceInfo'] as Map<String, dynamic>)
          : null,
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
      'recordId': recordId,
      'childId': childId,
      'childName': childName,
      'sleepDate': sleepDate.toIso8601String(),
      'sleepHoursTotal': sleepHoursTotal,
      'sleepHoursTotalFormatted': sleepHoursTotalFormatted,
      'sleepRefId': sleepRefId,
      'notes': notes,
      'status': status,
      'referenceInfo': (referenceInfo as SleepReferenceInfoModel?)?.toJson(),
    };
  }

  SleepRecordEntity toEntity() {
    return SleepRecordEntity(
      recordId: recordId,
      childId: childId,
      childName: childName,
      sleepDate: sleepDate,
      sleepHoursTotal: sleepHoursTotal,
      sleepHoursTotalFormatted: sleepHoursTotalFormatted,
      sleepRefId: sleepRefId,
      notes: notes,
      status: status,
      referenceInfo: referenceInfo,
    );
  }
}
