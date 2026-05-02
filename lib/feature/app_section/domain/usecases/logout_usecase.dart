import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/app_section/domain/repositories/app_section_repository_contract.dart';

@injectable
class LogoutUseCase {
  final AppSectionRepositoryContract _repository;
  LogoutUseCase(this._repository);
  Future<Either<Failure, void>> call(String refreshToken) async {
    return await _repository.logout(refreshToken);
  }
}
