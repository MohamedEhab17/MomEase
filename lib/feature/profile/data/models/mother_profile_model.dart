import 'package:equatable/equatable.dart';

class MotherProfileModel extends Equatable {
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

  const MotherProfileModel({
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

  factory MotherProfileModel.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['profilePictureUrl'];
    if (photoUrl != null && !photoUrl.startsWith('http')) {
      photoUrl = 'http://momease.runasp.net$photoUrl';
    }

    return MotherProfileModel(
      motherId: json['motherId'],
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      isFirstTimeMother: json['isFirstTimeMother'],
      numberOfChildren: json['numberOfChildren'],
      mentalHealthStatus: json['mentalHealthStatus'],
      healthStatus: json['healthStatus'],
      profilePictureUrl: photoUrl,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFirstTimeMother': isFirstTimeMother,
      'numberOfChildren': numberOfChildren,
      'mentalHealthStatus': mentalHealthStatus,
      'healthStatus': healthStatus,
    };
  }

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
