import 'package:new_mama/feature/children/domain/entities/child.dart';

class ChildModel extends Child {
  const ChildModel({
    required super.childId,
    required super.fullName,
    required super.gender,
    required super.birthDate,
    required super.ageInMonths,
    required super.ageInDays,
    required super.deliveryType,
    required super.feedingTypeForBaby,
    super.photoUrl,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      childId: json['childId'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      ageInMonths: json['ageInMonths'] as int? ?? 0,
      ageInDays: json['ageInDays'] as int? ?? 0,
      deliveryType: json['deliveryType'] as String? ?? '',
      feedingTypeForBaby: json['feedingTypeForBaby'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'fullName': fullName,
        'gender': gender,
        'birthDate': birthDate,
        'ageInMonths': ageInMonths,
        'ageInDays': ageInDays,
        'deliveryType': deliveryType,
        'feedingTypeForBaby': feedingTypeForBaby,
        'photoUrl': photoUrl,
      };

  /// Create a copy with updated fields.
  ChildModel copyWith({
    int? childId,
    String? fullName,
    String? gender,
    String? birthDate,
    int? ageInMonths,
    int? ageInDays,
    String? deliveryType,
    String? feedingTypeForBaby,
    String? photoUrl,
  }) {
    return ChildModel(
      childId: childId ?? this.childId,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      ageInMonths: ageInMonths ?? this.ageInMonths,
      ageInDays: ageInDays ?? this.ageInDays,
      deliveryType: deliveryType ?? this.deliveryType,
      feedingTypeForBaby: feedingTypeForBaby ?? this.feedingTypeForBaby,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
