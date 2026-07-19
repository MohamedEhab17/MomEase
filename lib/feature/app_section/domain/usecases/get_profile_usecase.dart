import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/app_section/domain/entities/user_entity.dart';
import 'package:new_mama/feature/app_section/domain/repositories/app_section_repository_contract.dart';
@injectable
class GetProfileUsecase {


  final AppSectionRepositoryContract repository;

  GetProfileUsecase(this.repository);

  Future<Either<Failure, UserEntity >> call() {
    return repository.getProfile();
  
  }
}