import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class RevokeTokenUseCase {
  final AuthRepository _repository;

  RevokeTokenUseCase(this._repository);

  Future<Either<Failure, String>> call(String refreshToken) async {
    return await _repository.revokeToken(refreshToken: refreshToken);
  }
}
