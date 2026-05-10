import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/profile/domain/entity/mother_profile.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../datasource/profile_remote_datasource.dart';
import '../models/mother_profile_model.dart';
import '../../domain/repository/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, MotherProfile>> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
      return Right(_mapModelToEntity(model));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, MotherProfile>> updateProfile(MotherProfile profile) async {
    try {
      final model = _mapEntityToModel(profile);
      final updatedModel = await _remoteDataSource.updateProfile(model);
      return Right(_mapModelToEntity(updatedModel));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(String filePath) async {
    try {
      String photoUrl = await _remoteDataSource.uploadPhoto(filePath);
      if (!photoUrl.startsWith('http')) {
        photoUrl = 'http://momease.runasp.net$photoUrl';
      }
      return Right(photoUrl);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePhoto() async {
    try {
      await _remoteDataSource.deletePhoto();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  MotherProfile _mapModelToEntity(MotherProfileModel model) {
    return MotherProfile(
      motherId: model.motherId,
      userId: model.userId,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      isFirstTimeMother: model.isFirstTimeMother,
      numberOfChildren: model.numberOfChildren,
      mentalHealthStatus: model.mentalHealthStatus,
      healthStatus: model.healthStatus,
      profilePictureUrl: model.profilePictureUrl,
      createdAt: model.createdAt,
    );
  }

  MotherProfileModel _mapEntityToModel(MotherProfile entity) {
    return MotherProfileModel(
      motherId: entity.motherId,
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      isFirstTimeMother: entity.isFirstTimeMother,
      numberOfChildren: entity.numberOfChildren,
      mentalHealthStatus: entity.mentalHealthStatus,
      healthStatus: entity.healthStatus,
      profilePictureUrl: entity.profilePictureUrl,
      createdAt: entity.createdAt,
    );
  }
}
