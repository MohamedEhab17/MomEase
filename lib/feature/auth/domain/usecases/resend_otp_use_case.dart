import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class ResendOtpUseCase {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  Future<Either<Failure, String>> call(String email) async {
    return await _repository.resendOtp(email: email);
  }
}
