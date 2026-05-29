import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/app_section/data/model/user_model.dart';

abstract class AppSectionRemoteDatasourceContract {
    Future<Either<Failure, void>> logout(String refreshToken);
  Future<Either<Failure, UserModel>> getProfile();
  Future<Either<Failure, UserModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
  });
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}