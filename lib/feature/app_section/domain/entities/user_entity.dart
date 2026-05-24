import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int age;
  final String role;
  final String createdAt;
  final String? profilePictureUrl;

  const UserEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.age,
    required this.role,
    required this.createdAt,
    this.profilePictureUrl,
  });
  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        email,
        phone,
        age,
        role,
        createdAt,
        profilePictureUrl,
      ];
}