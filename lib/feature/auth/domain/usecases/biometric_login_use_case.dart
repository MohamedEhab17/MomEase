import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/usecase.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/helper/biometric_helper.dart';
import 'package:new_mama/feature/auth/domain/entities/user.dart';
import 'package:new_mama/feature/auth/domain/repositories/auth_repository.dart';

@injectable
class BiometricLoginUseCase implements UseCase<User, NoParams> {
  final AuthRepository _repository;
  final BiometricHelper _biometricHelper;

  BiometricLoginUseCase(this._repository, this._biometricHelper);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    final cachedUserEither = await _repository.getCachedUser();

    return cachedUserEither.fold(
      (failure) {
        return const Left(CacheFailure('No user found for biometric login. Please login with password first.'));
      },
      (user) async {
        final isAvailable = await _biometricHelper.isBiometricAvailable();
        if (!isAvailable) {
          return const Left(ServerFailure('Biometrics not available on this device.'));
        }

        final (success, errorMessage) = await _biometricHelper.authenticate(
          localizedReason: 'Authenticate to access MomEase securely',
        );

        if (success) {
          return Right(user);
        } else {
          return Left(ServerFailure(errorMessage ?? 'Biometric authentication failed.'));
        }
      },
    );
  }
}
