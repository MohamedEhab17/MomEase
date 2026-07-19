import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/app_section/domain/entities/user_entity.dart';

abstract class ManageProfileState extends Equatable {
  const ManageProfileState();

  @override
  List<Object?> get props => [];
}

class ManageProfileInitial extends ManageProfileState {}

class ManageProfileLoading extends ManageProfileState {}

class ManageProfileSuccess extends ManageProfileState {
  final UserEntity user;
  const ManageProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ChangePasswordSuccess extends ManageProfileState {
  final String message;
  const ChangePasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ManageProfileError extends ManageProfileState {
  final String message;
  const ManageProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
