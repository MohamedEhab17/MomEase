import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';

class FeedingRecordModel extends FeedingRecordEntity {
  const FeedingRecordModel({
    required super.recordId,
    required super.childId,
    required super.childName,
    required super.feedingDate,
    required super.feedingTimesPerDay,
    required super.feedingTypeForBaby,
    required super.feedingType,
    required super.notes,
    super.referenceInfo,
  });

  factory FeedingRecordModel.fromJson(Map<String, dynamic> json) {
    return FeedingRecordModel(
      recordId: json['recordId'] as int? ?? 0,
      childId: json['childId'] as int? ?? 0,
      childName: json['childName'] as String? ?? '',
      feedingDate: json['feedingDate'] != null
          ? DateTime.parse(json['feedingDate'] as String)
          : DateTime.now(),
      feedingTimesPerDay: json['feedingTimesPerDay'] as int? ?? 0,
      feedingTypeForBaby: json['feedingTypeForBaby'] as String? ?? '',
      feedingType: json['feedingType'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      referenceInfo: json['referenceInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'childId': childId,
      'childName': childName,
      'feedingDate': feedingDate.toIso8601String(),
      'feedingTimesPerDay': feedingTimesPerDay,
      'feedingTypeForBaby': feedingTypeForBaby,
      'feedingType': feedingType,
      'notes': notes,
      'referenceInfo': referenceInfo,
    };
  }

  FeedingRecordEntity toEntity() {
    return FeedingRecordEntity(
      recordId: recordId,
      childId: childId,
      childName: childName,
      feedingDate: feedingDate,
      feedingTimesPerDay: feedingTimesPerDay,
      feedingTypeForBaby: feedingTypeForBaby,
      feedingType: feedingType,
      notes: notes,
      referenceInfo: referenceInfo,
    );
  }
}
