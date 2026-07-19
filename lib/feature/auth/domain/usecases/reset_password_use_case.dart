import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordParams {
  final String email;
  final String otpCode;
  final String newPassword;

  ResetPasswordParams({
    required this.email,
    required this.otpCode,
    required this.newPassword,
  });
}

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, String>> call(ResetPasswordParams params) async {
    return await _repository.resetPassword(
      email: params.email,
      otpCode: params.otpCode,
      newPassword: params.newPassword,
    );
  }
}
