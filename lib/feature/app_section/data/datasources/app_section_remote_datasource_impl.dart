

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_remote_datasource_contract.dart';
import 'package:new_mama/feature/app_section/data/model/user_model.dart';

@LazySingleton(as: AppSectionRemoteDatasourceContract)
class AppSectionRemoteDatasourceImpl implements AppSectionRemoteDatasourceContract {
  final ApiClient _apiClient;
  AppSectionRemoteDatasourceImpl(this._apiClient);
  Options get _headers => Options(
    headers: {'Accept-Language': getIt<LanguageCubit>().state.languageCode},
  );

  // dynamic _normalizeData(dynamic data) {
  //   if (data is String && data.trim().isNotEmpty) {
  //     try {
  //       return jsonDecode(data);
  //     } catch (_) {}
  //   }
  //   return data;
  // }

  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {
    try {
      await _apiClient.post(
        Api.revokeToken,
        data: {'refreshToken': refreshToken},
        options: _headers,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

   @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final response = await _apiClient.get(Api.getUser, options: _headers);
      final data = response.data;
      final responseData = data['data'] ?? data;
      final userModel = UserModel.fromJson(responseData);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
  }) async {
    try {
      final response = await _apiClient.put(
        Api.updateProfile,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'age': age,
        },
        options: _headers,
      );
      final data = response.data;
      final responseData = data['data'] ?? data;
      final userModel = UserModel.fromJson(responseData);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final response = await _apiClient.put(
        Api.changeUserPassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        },
        options: _headers,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return const Right(null);
      } else {
        return Left(ServerFailure(data['message'] ?? 'Failed to change password'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
