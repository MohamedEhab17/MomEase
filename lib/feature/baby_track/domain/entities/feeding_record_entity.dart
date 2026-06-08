import 'package:equatable/equatable.dart';

class FeedingRecordEntity extends Equatable {
  final int recordId;
  final int childId;
  final String childName;
  final DateTime feedingDate;
  final int feedingTimesPerDay;
  final String feedingTypeForBaby;
  final String feedingType;
  final String notes;
  final dynamic referenceInfo;

  const FeedingRecordEntity({
    required this.recordId,
    required this.childId,
    required this.childName,
    required this.feedingDate,
    required this.feedingTimesPerDay,
    required this.feedingTypeForBaby,
    required this.feedingType,
    required this.notes,
    this.referenceInfo,
  });

  @override
  List<Object?> get props => [
        recordId,
        childId,
        childName,
        feedingDate,
        feedingTimesPerDay,
        feedingTypeForBaby,
        feedingType,
        notes,
        referenceInfo,
      ];
}
