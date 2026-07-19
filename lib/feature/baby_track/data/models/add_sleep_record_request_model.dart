class AddSleepRecordRequestModel {
  final int childId;
  final DateTime sleepDate;
  final String sleepStartTime; // format "HH:mm"
  final String sleepEndTime; // format "HH:mm"
  final String quality;
  final String notes;

  const AddSleepRecordRequestModel({
    required this.childId,
    required this.sleepDate,
    required this.sleepStartTime,
    required this.sleepEndTime,
    required this.quality,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'sleepDate': sleepDate.toIso8601String(),
      'sleepStartTime': sleepStartTime,
      'sleepEndTime': sleepEndTime,
      'quality': quality,
      'notes': notes,
    };
  }
}
