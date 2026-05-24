import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/auth/domain/entities/user.dart';
import 'package:new_mama/feature/auth/domain/repositories/auth_repository.dart';

/// Domain use case: single responsibility — orchestrate login through the repository.
@injectable
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
