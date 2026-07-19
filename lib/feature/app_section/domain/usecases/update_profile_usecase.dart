import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/app_section/domain/entities/user_entity.dart';
import 'package:new_mama/feature/app_section/domain/repositories/app_section_repository_contract.dart';

@injectable
class UpdateProfileUsecase {
  final AppSectionRepositoryContract repository;

  UpdateProfileUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
  }) {
    return repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      age: age,
    );
  }
}
