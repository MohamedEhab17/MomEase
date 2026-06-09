import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'cry_analysis_remote_data_source.dart';
import '../models/cry_analysis_model.dart';

@LazySingleton(as: CryAnalysisRemoteDataSource)
class CryAnalysisRemoteDataSourceImpl implements CryAnalysisRemoteDataSource {
  final ApiClient _apiClient;

  CryAnalysisRemoteDataSourceImpl(this._apiClient);

  Options get _headers => Options(
        headers: {'Accept-Language': getIt<LanguageCubit>().state.languageCode},
      );

  @override
  Future<CryAnalysisModel> analyzeCry({
    required File audioFile,
    required int childId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
      });

      final response = await _apiClient.post(
        Api.childCryAnalysis(childId),
        data: formData,
        options: Options(
          headers: {
            'Accept-Language': getIt<LanguageCubit>().state.languageCode,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return CryAnalysisModel.fromJson(data);
      }

      throw ServerException('Failed to analyze cry');
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to analyze cry');
    }
  }

  @override
  Future<List<CryAnalysisModel>> getUserCryAnalyses() async {
    try {
      final response = await _apiClient.get(
        Api.cryAnalysis,
        options: _headers,
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => CryAnalysisModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to fetch cry analyses');
    }
  }

  @override
  Future<List<CryAnalysisModel>> getChildCryAnalyses(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childCryAnalysis(childId),
        options: _headers,
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => CryAnalysisModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to fetch child cry analyses');
    }
  }

  @override
  Future<void> deleteCryAnalysis(int cryId) async {
    try {
      await _apiClient.delete(
        Api.cryAnalysisById(cryId),
        options: _headers,
      );
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to delete cry analysis');
    }
  }
}
