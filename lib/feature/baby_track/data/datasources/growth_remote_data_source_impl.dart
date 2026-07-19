import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/di/injection.dart';

import 'package:new_mama/feature/baby_track/data/datasources/growth_remote_data_source_contract.dart';
import 'package:new_mama/feature/baby_track/data/models/growth_record_model.dart';
import 'package:new_mama/feature/baby_track/data/models/add_growth_record_request_model.dart';
import 'package:new_mama/feature/baby_track/data/models/growth_chart_data_model.dart';
import 'package:new_mama/feature/baby_track/data/models/growth_statistics_model.dart';
import 'package:new_mama/feature/baby_track/data/models/weekly_growth_records_model.dart';
import 'package:new_mama/feature/baby_track/data/models/monthly_growth_records_model.dart';

@LazySingleton(as: GrowthRemoteDataSourceContract)
class GrowthRemoteDataSourceImpl implements GrowthRemoteDataSourceContract {
  final ApiClient _apiClient;

  GrowthRemoteDataSourceImpl(this._apiClient);

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

  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data.containsKey('message') &&
          data['message'] != null &&
          data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }
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
  Future<GrowthRecordModel> addGrowthRecord(
    int childId,
    AddGrowthRecordRequestModel body,
  ) async {
    try {
      final response = await _apiClient.post(
        Api.childGrowthRecords(childId),
        data: body.toJson(),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data['data'] != null) {
        return GrowthRecordModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw ServerException(_extractErrorMessage(data));
    } on DioException catch (e) {
      final data = _normalizeData(e.response?.data);
      throw ServerException(_extractErrorMessage(data ?? e.message));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<GrowthRecordModel>> getGrowthRecords(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childGrowthRecords(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data['data'] != null) {
        final list = data['data'] as List;
        return list.map((e) => GrowthRecordModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw ServerException(_extractErrorMessage(data));
    } on DioException catch (e) {
      final data = _normalizeData(e.response?.data);
      throw ServerException(_extractErrorMessage(data ?? e.message));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteGrowthRecord(int childId, int id) async {
    try {
      final response = await _apiClient.delete(
        Api.childGrowthRecordById(childId, id),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true) {
        return;
      }
      throw ServerException(_extractErrorMessage(data));
    } on DioException catch (e) {
      final data = _normalizeData(e.response?.data);
      throw ServerException(_extractErrorMessage(data ?? e.message));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GrowthChartDataModel> getGrowthChartData(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childGrowthRecordsChart(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data['data'] != null) {
        return GrowthChartDataModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw ServerException(_extractErrorMessage(data));
    } on DioException catch (e) {
      final data = _normalizeData(e.response?.data);
      throw ServerException(_extractErrorMessage(data ?? e.message));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GrowthStatisticsModel> getGrowthStatistics(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childGrowthRecordsStatistics(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data['data'] != null) {
        return GrowthStatisticsModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw ServerException(_extractErrorMessage(data));
    } on DioException catch (e) {
      final data = _normalizeData(e.response?.data);
      throw ServerException(_extractErrorMessage(data ?? e.message));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<WeeklyGrowthRecordsModel> getWeeklyGrowthRecords(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childGrowthRecordsWeekly(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data['data'] != null) {
        return WeeklyGrowthRecordsModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw ServerException(_extractErrorMessage(data));
    } on DioException catch (e) {
      final data = _normalizeData(e.response?.data);
      throw ServerException(_extractErrorMessage(data ?? e.message));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MonthlyGrowthRecordsModel> getMonthlyGrowthRecords(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childGrowthRecordsMonthly(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> &&
          data['success'] == true &&
          data['data'] != null) {
        return MonthlyGrowthRecordsModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw ServerException(_extractErrorMessage(data));
    } on DioException catch (e) {
      final data = _normalizeData(e.response?.data);
      throw ServerException(_extractErrorMessage(data ?? e.message));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
