import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/mother_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, MotherProfile>> getProfile();
  Future<Either<Failure, MotherProfile>> updateProfile(MotherProfile profile);
  Future<Either<Failure, String>> uploadPhoto(String filePath);
  Future<Either<Failure, void>> deletePhoto();
}
