import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/skin_diagnosis/data/datasources/skin_analysis_remote_data_source.dart';
import 'package:new_mama/feature/skin_diagnosis/data/models/skin_analysis_model.dart';

@LazySingleton(as: SkinAnalysisRemoteDataSource)
class SkinAnalysisRemoteDataSourceImpl implements SkinAnalysisRemoteDataSource {
  final ApiClient _apiClient;

  SkinAnalysisRemoteDataSourceImpl(this._apiClient);

  Options get _headers => Options(
    headers: {'Accept-Language': getIt<LanguageCubit>().state.languageCode},
  );

  @override
  Future<SkinAnalysisModel> analyzeImage({
    required File image,
    required int childId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'childId': childId,
      });

      final response = await _apiClient.post(
        Api.skinAnalyze,
        data: formData,
        options: Options(
          headers: {
            'Accept-Language': getIt<LanguageCubit>().state.languageCode,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data['data'] != null) {
        return SkinAnalysisModel.fromJson(data['data'] as Map<String, dynamic>);
      }

      final message = data is Map ? data['message']?.toString() : null;
      throw ServerException(message ?? 'Failed to analyze image');
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to analyze image');
    }
  }

  @override
  Future<List<SkinAnalysisModel>> getUserAnalyses() async {
    try {
      final response = await _apiClient.get(
        Api.skinUserAnalyses,
        options: _headers,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => SkinAnalysisModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to fetch analyses');
    }
  }

  @override
  Future<List<SkinAnalysisModel>> getChildAnalyses(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.skinChildAnalyses(childId),
        options: _headers,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => SkinAnalysisModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to fetch child analyses');
    }
  }

  @override
  Future<void> deleteAnalysis(int analysisId) async {
    try {
      final response = await _apiClient.delete(
        Api.skinAnalysisById(analysisId),
        options: _headers,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) return;

      final message = data is Map ? data['message']?.toString() : null;
      throw ServerException(message ?? 'Failed to delete analysis');
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to delete analysis');
    }
  }
}
