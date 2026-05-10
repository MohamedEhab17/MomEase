import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:dio/dio.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_remote_datasource_contract.dart';
import 'package:new_mama/feature/app_section/domain/entities/user_entity.dart';
import 'package:new_mama/feature/app_section/domain/repositories/app_section_repository_contract.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:get_it/get_it.dart';
import 'package:new_mama/feature/auth/domain/repositories/auth_repository.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';

@LazySingleton(as: AppSectionRepositoryContract)
class AppSectionRepositoryImpl implements AppSectionRepositoryContract {
  final AppSectionRemoteDatasourceContract _remoteDatasource;
  final AuthLocalDataSource _localDataSource;

  AppSectionRepositoryImpl(this._remoteDatasource, this._localDataSource);
  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {
    try {
      // 1. Call remote logout
      await _remoteDatasource.logout(refreshToken);
    } catch (e) {
      // Continue cleanup even if remote call fails
    }

    try {
      // 2. Clear local auth data
      await _localDataSource.clearAll();

      // 3. Reset critical singletons to clear stale state/interceptors
      final getIt = GetIt.instance;
      if (getIt.isRegistered<Dio>()) {
        await getIt.resetLazySingleton<Dio>();
      }
      if (getIt.isRegistered<ApiClient>()) {
        await getIt.resetLazySingleton<ApiClient>();
      }
      if (getIt.isRegistered<ProfileCubit>()) {
        await getIt.resetLazySingleton<ProfileCubit>();
      }
      if (getIt.isRegistered<ChildrenCubit>()) {
        await getIt.resetLazySingleton<ChildrenCubit>();
      }
      if (getIt.isRegistered<ActiveChildCubit>()) {
        await getIt.resetLazySingleton<ActiveChildCubit>();
      }
      if (getIt.isRegistered<AuthRepository>()) {
        await getIt.resetLazySingleton<AuthRepository>();
      }
      if (getIt.isRegistered<AppSectionRepositoryContract>()) {
        await getIt.resetLazySingleton<AppSectionRepositoryContract>();
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Logout cleanup failed: ${e.toString()}"));
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
