class AddSleepRecordRequestModel {
  final DateTime sleepDate;
  final String sleepHoursTotal; // format "HH:mm:ss"
  final String notes;

  const AddSleepRecordRequestModel({
    required this.sleepDate,
    required this.sleepHoursTotal,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'sleepDate': sleepDate.toIso8601String(),
      'sleepHoursTotal': sleepHoursTotal,
      'notes': notes,
    };
  }
}
