class UpdateVaccinationRequestModel {
  final String status;
  final DateTime? takenDate;

  const UpdateVaccinationRequestModel({
    required this.status,
    this.takenDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'takenDate': takenDate?.toIso8601String(),
    };
  }
}
