import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });
}

@lazySingleton
class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<Either<Failure, String>> call(ChangePasswordParams params) async {
    return await _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
      confirmNewPassword: params.confirmNewPassword,
    );
  }
}
