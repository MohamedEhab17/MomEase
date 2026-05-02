

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_remote_datasource_contract.dart';

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
        Api.logout,
        data: {'refresh_token': refreshToken},
        options: _headers,
      );

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
