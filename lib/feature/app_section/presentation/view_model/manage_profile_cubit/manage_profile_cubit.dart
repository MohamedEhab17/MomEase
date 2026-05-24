import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/app_section/domain/usecases/change_password_usecase.dart';
import 'package:new_mama/feature/app_section/domain/usecases/update_profile_usecase.dart';
import 'manage_profile_state.dart';

@injectable
class ManageProfileCubit extends Cubit<ManageProfileState> {
  final UpdateProfileUsecase _updateProfileUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;

  ManageProfileCubit(
    this._updateProfileUsecase,
    this._changePasswordUsecase,
  ) : super(ManageProfileInitial());

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
  }) async {
    emit(ManageProfileLoading());

    final result = await _updateProfileUsecase(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      age: age,
    );

    result.fold(
      (failure) => emit(ManageProfileError(failure.message)),
      (user) => emit(ManageProfileSuccess(user)),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(ManageProfileLoading());

    final result = await _changePasswordUsecase(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );

    result.fold(
      (failure) => emit(ManageProfileError(failure.message)),
      (_) => emit(const ChangePasswordSuccess("Password changed successfully")),
    );
  }
}
