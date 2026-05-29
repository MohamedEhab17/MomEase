import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/feature/depression/data/datasources/assessment_remote_data_source_contract.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/di/injection.dart';

import 'package:new_mama/feature/depression/data/models/assessments_model.dart';
import 'package:new_mama/feature/depression/data/models/question_model.dart';
import 'package:new_mama/feature/depression/data/models/option_model.dart';
import 'package:new_mama/feature/depression/data/models/assessment_result_model.dart';
import 'package:new_mama/feature/depression/data/models/submit_request_model.dart';

@LazySingleton(as: AssessmentRemoteDataSourceContract)
class AssessmentRemoteDataSourceImpl implements AssessmentRemoteDataSourceContract {
  final ApiClient _apiClient;

  AssessmentRemoteDataSourceImpl(this._apiClient);

  Options get _headers => Options(
        headers: {'Accept-Language': getIt<LanguageCubit>().state.languageCode},
      );

  dynamic _normalizeData(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      try {
        return jsonDecode(data);
      } catch (_) {}
    }
    return data;
  }

  @override
  Future<List<AssessmentsModel>> getAssessments() async {
    final response = await _apiClient.get(Api.getAssessments, options: _headers);
    final data = _normalizeData(response.data);
    if (data is! List) return [];
    return data.map((json) => AssessmentsModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<AssessmentsModel> getAssessmentById(int id) async {
    final response = await _apiClient.get('${Api.getAssessments}/$id', options: _headers);
    final data = _normalizeData(response.data);

    if (data == null || data is! Map) {
      throw const ServerException('Invalid assessment data format');
    }
    return AssessmentsModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<QuestionModel>> getQuestions(int assessmentId) async {
    final response = await _apiClient.get(
      Api.getQuestions.replaceAll('{assessmentId}', assessmentId.toString()),
      options: _headers,
    );
    final data = _normalizeData(response.data);
    if (data is! List) return [];
    return data.map((json) => QuestionModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<OptionModel>> getOptionsByQuestionId(int questionId) async {
    final url = Api.getOptionsByQuestionId.replaceAll('{questionId}', questionId.toString());
    final response = await _apiClient.get(url, options: _headers);
    
    final data = _normalizeData(response.data);
    if (data is! List) return [];
    
    final options = data.map((json) => OptionModel.fromJson(json as Map<String, dynamic>)).toList();
    options.sort((a, b) => a.optionOrder.compareTo(b.optionOrder));
    return options;
  }

  @override
  Future<AssessmentResultModel> submitAssessment(int assessmentId, SubmitRequestModel body) async {
    try {
      final response = await _apiClient.post(
        Api.submitAssessment.replaceAll('{assessmentId}', assessmentId.toString()),
        data: body.toJson(),
        options: _headers,
      );

      final data = _normalizeData(response.data);

      if (response.statusCode != null && response.statusCode! >= 400) {
        throw ServerException(_extractErrorMessage(data));
      }

      if (data is Map<String, dynamic> && data['success'] == true && data['data'] != null) {
        return AssessmentResultModel.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw const ServerException('Failed to process submission. Unrecognized response structure.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerException('Unauthorized access. Session expired.');
      }
      rethrow;
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstVal = errors[firstKey];
          if (firstVal is List && firstVal.isNotEmpty) {
            return '${firstKey.toString()}: ${firstVal.first.toString()}';
          }
          return errors.toString();
        }
        return errors.toString();
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return 'An unknown server error occurred.';
  }

  @override
  Future<QuestionModel> getQuestionById(int assessmentId, int questionId) async {
    final response = await _apiClient.get(
      Api.getQuestionById
          .replaceAll('{assessmentId}', assessmentId.toString())
          .replaceAll('{questionId}', questionId.toString()),
      options: _headers,
    );

    final data = _normalizeData(response.data);
    if (data == null || data is! Map) {
       throw const ServerException('Invalid question data format');
    }

    final question = QuestionModel.fromJson(data as Map<String, dynamic>);
    final options = await getOptionsByQuestionId(questionId);

    return question.copyWith(options: options);
  }

  @override
  Future<AssessmentResultModel> getAssessmentResult(int id) async {
    try {
      final response = await _apiClient.get(
        Api.getAssessmentResult.replaceAll('{id}', id.toString()),
        options: _headers,
      );

      final data = _normalizeData(response.data);
      if (data == null || data is! Map<String, dynamic>) {
        throw const ServerException('Invalid response format');
      }

      return AssessmentResultModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AssessmentResultModel>> getUserAssessmentResults() async {
    try {
      final response = await _apiClient.get(
        Api.assessmentResultsHistory,
        options: _headers,
      );

      final data = _normalizeData(response.data);
      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => AssessmentResultModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to fetch history');
    }
  }

  @override
  Future<void> deleteAssessmentResult(int id) async {
    try {
      final response = await _apiClient.delete(
        Api.deleteAssessmentResult(id),
        options: _headers,
      );

      final data = _normalizeData(response.data);
      if (data is Map<String, dynamic> && data['success'] == true) return;

      final message = data is Map ? data['message']?.toString() : null;
      throw ServerException(message ?? 'Failed to delete assessment result');
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = body is Map ? body['message']?.toString() : e.message;
      throw ServerException(message ?? 'Failed to delete assessment result');
    }
  }
}
