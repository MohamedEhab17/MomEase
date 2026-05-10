import 'package:equatable/equatable.dart';

class MotherProfile extends Equatable {
  final int motherId;
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final bool isFirstTimeMother;
  final int numberOfChildren;
  final String? mentalHealthStatus;
  final String? healthStatus;
  final String? profilePictureUrl;
  final DateTime createdAt;

  const MotherProfile({
    required this.motherId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isFirstTimeMother,
    required this.numberOfChildren,
    this.mentalHealthStatus,
    this.healthStatus,
    this.profilePictureUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        motherId,
        userId,
        firstName,
        lastName,
        email,
        isFirstTimeMother,
        numberOfChildren,
        mentalHealthStatus,
        healthStatus,
        profilePictureUrl,
        createdAt,
      ];
}
