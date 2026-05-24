import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  const User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, firstName, lastName, email, role];
}
