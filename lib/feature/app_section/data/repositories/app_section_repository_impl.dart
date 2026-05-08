import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:dio/dio.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_remote_datasource_contract.dart';
import 'package:new_mama/feature/app_section/domain/entities/user_entity.dart';
import 'package:new_mama/feature/app_section/domain/repositories/app_section_repository_contract.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:get_it/get_it.dart';

@LazySingleton(as: AppSectionRepositoryContract)
class AppSectionRepositoryImpl implements AppSectionRepositoryContract {
  final AppSectionRemoteDatasourceContract _remoteDatasource;
  final AuthLocalDataSource _localDataSource;

  AppSectionRepositoryImpl(this._remoteDatasource, this._localDataSource);
  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {

try {
      await _remoteDatasource.logout(refreshToken);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

   @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    return await _remoteDatasource.getProfile();
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
  }) async {
    return await _remoteDatasource.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      age: age,
    );
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final result = await _remoteDatasource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );

    return result.fold(
      (failure) => Left(failure),
      (_) async {
        try {
          await _localDataSource.clearAll();
          // Reset Dio and ApiClient to clear any queued requests or stale interceptor state
          final getIt = GetIt.instance;
          if (getIt.isRegistered<Dio>()) {
            await getIt.resetLazySingleton<Dio>();
          }
          if (getIt.isRegistered<ApiClient>()) {
            await getIt.resetLazySingleton<ApiClient>();
          }
          return const Right(null);
        } catch (e) {
          return Left(CacheFailure("Failed to clear local session: ${e.toString()}"));
        }
      },
    );
  }
}
