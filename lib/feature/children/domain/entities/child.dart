import 'package:equatable/equatable.dart';

class Child extends Equatable {
  final int childId;
  final String fullName;
  final String gender;
  final String birthDate;
  final int ageInMonths;
  final int ageInDays;
  final String deliveryType;
  final String feedingTypeForBaby;
  final String? photoUrl;

  const Child({
    required this.childId,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.ageInMonths,
    required this.ageInDays,
    required this.deliveryType,
    required this.feedingTypeForBaby,
    this.photoUrl,
  });

  /// Convenience label. e.g. "3 months old" or "45 days old".
  String get ageLabel {
    if (ageInMonths >= 1) {
      return '$ageInMonths month${ageInMonths == 1 ? '' : 's'} old';
    }
    return '$ageInDays day${ageInDays == 1 ? '' : 's'} old';
  }

  bool get isBoy => gender.toLowerCase() == 'boy';

  @override
  List<Object?> get props => [
        childId,
        fullName,
        gender,
        birthDate,
        ageInMonths,
        ageInDays,
        deliveryType,
        feedingTypeForBaby,
        photoUrl,
      ];
}
