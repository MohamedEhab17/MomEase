import 'package:new_mama/feature/app_section/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.userId, required super.firstName, required super.lastName, required super.email, required super.phone, required super.age, required super.role, required super.createdAt, super.profilePictureUrl});

factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0,
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}