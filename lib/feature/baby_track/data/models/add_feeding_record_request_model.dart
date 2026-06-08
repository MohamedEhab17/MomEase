class AddFeedingRecordRequestModel {
  final DateTime feedingDate;
  final int feedingTimesPerDay;
  final String feedingTypeForBaby; // "breastfeeding", "formulafeeding", "solidfood", "mixed"
  final String notes;

  const AddFeedingRecordRequestModel({
    required this.feedingDate,
    required this.feedingTimesPerDay,
    required this.feedingTypeForBaby,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      // camelCase
      'feedingDate': feedingDate.toIso8601String(),
      'feedingTimesPerDay': feedingTimesPerDay,
      'feedingTypeForBaby': feedingTypeForBaby,
      'notes': notes,
      // PascalCase
      'FeedingDate': feedingDate.toIso8601String(),
      'FeedingTimesPerDay': feedingTimesPerDay,
      'FeedingTypeForBaby': feedingTypeForBaby,
      'Notes': notes,
    };
  }
}
