import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';

/// Params carrier for creating a new child.
class CreateChildParams {
  final String fullName;
  final String gender;

  /// ISO 8601 string, e.g. "2024-01-15T00:00:00.000Z"
  final String birthDate;
  final String deliveryType;
  final String feedingTypeForBaby;

  const CreateChildParams({
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.deliveryType,
    required this.feedingTypeForBaby,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'gender': gender,
        'birthDate': birthDate,
        'deliveryType': deliveryType,
        'feedingTypeForBaby': feedingTypeForBaby,
      };
}

/// Params carrier for updating a child — all fields optional.
class UpdateChildParams {
  final String? fullName;
  final String? gender;
  final String? birthDate;
  final String? deliveryType;
  final String? feedingTypeForBaby;

  const UpdateChildParams({
    this.fullName,
    this.gender,
    this.birthDate,
    this.deliveryType,
    this.feedingTypeForBaby,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fullName != null) map['fullName'] = fullName;
    if (gender != null) map['gender'] = gender;
    if (birthDate != null) map['birthDate'] = birthDate;
    if (deliveryType != null) map['deliveryType'] = deliveryType;
    if (feedingTypeForBaby != null) map['feedingTypeForBaby'] = feedingTypeForBaby;
    return map;
  }
}

abstract class ChildrenRepository {
  Future<Either<Failure, List<Child>>> getChildren();
  Future<Either<Failure, Child>> getChild(int childId);
  Future<Either<Failure, Child>> createChild(CreateChildParams params);
  Future<Either<Failure, Child>> updateChild(int childId, UpdateChildParams params);
  Future<Either<Failure, String>> deleteChild(int childId);
  Future<Either<Failure, String>> uploadPhoto(int childId, File photo);
  Future<Either<Failure, String>> deletePhoto(int childId);
}
