import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class GoogleLoginUseCase {
  final AuthRepository _repository;

  GoogleLoginUseCase(this._repository);

  Future<Either<Failure, User>> call(String idToken) async {
    return await _repository.googleLogin(idToken: idToken);
  }
}
