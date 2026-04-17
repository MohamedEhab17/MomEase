import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyEmailUseCase {
  final AuthRepository _repository;

  VerifyEmailUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required String email,
    required String otpCode,
  }) {
    return _repository.verifyEmail(
      email: email,
      otpCode: otpCode,
    );
  }
}
