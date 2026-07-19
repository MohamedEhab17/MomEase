import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entity/mother_profile.dart';
import '../repository/profile_repository.dart';

@injectable
class GetMotherProfileUseCase {
  final ProfileRepository repository;
  GetMotherProfileUseCase(this.repository);

  Future<Either<Failure, MotherProfile>> call() {
    return repository.getProfile();
  }
}

@injectable
class UpdateMotherProfileUseCase {
  final ProfileRepository repository;
  UpdateMotherProfileUseCase(this.repository);

  Future<Either<Failure, MotherProfile>> call(MotherProfile profile) {
    return repository.updateProfile(profile);
  }
}

@injectable
class UploadProfilePhotoUseCase {
  final ProfileRepository repository;
  UploadProfilePhotoUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath) {
    return repository.uploadPhoto(filePath);
  }
}

@injectable
class DeleteProfilePhotoUseCase {
  final ProfileRepository repository;
  DeleteProfilePhotoUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.deletePhoto();
  }
}
