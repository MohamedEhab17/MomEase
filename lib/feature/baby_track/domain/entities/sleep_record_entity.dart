import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_reference_info_entity.dart';

class SleepRecordEntity extends Equatable {
  final int recordId;
  final int childId;
  final String childName;
  final DateTime sleepDate;
  final String sleepHoursTotal;
  final String sleepHoursTotalFormatted;
  final int? sleepRefId;
  final String notes;
  final String status;
  final SleepReferenceInfoEntity? referenceInfo;

  const SleepRecordEntity({
    required this.recordId,
    required this.childId,
    required this.childName,
    required this.sleepDate,
    required this.sleepHoursTotal,
    required this.sleepHoursTotalFormatted,
    this.sleepRefId,
    required this.notes,
    required this.status,
    this.referenceInfo,
  });

  @override
  List<Object?> get props => [
        recordId,
        childId,
        childName,
        sleepDate,
        sleepHoursTotal,
        sleepHoursTotalFormatted,
        sleepRefId,
        notes,
        status,
        referenceInfo,
      ];
}
