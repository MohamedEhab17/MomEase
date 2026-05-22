import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/di/injection.dart';

import 'package:new_mama/feature/baby_track/data/datasources/vaccination_remote_data_source_contract.dart';
import 'package:new_mama/feature/baby_track/data/models/vaccine_model.dart';
import 'package:new_mama/feature/baby_track/data/models/vaccine_group_model.dart';
import 'package:new_mama/feature/baby_track/data/models/update_vaccination_request_model.dart';

@LazySingleton(as: VaccinationRemoteDataSourceContract)
class VaccinationRemoteDataSourceImpl implements VaccinationRemoteDataSourceContract {
  final ApiClient _apiClient;

  VaccinationRemoteDataSourceImpl(this._apiClient);

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
      if (data.containsKey('message') && data['message'] != null && data['message'].toString().isNotEmpty) {
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
  Future<List<VaccineGroupModel>> getVaccinations(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childVaccinations(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => VaccineGroupModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
  Future<VaccineModel> getVaccinationById(int childId, int id) async {
    try {
      final response = await _apiClient.get(
        Api.childVaccinationById(childId, id),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true && data['data'] != null) {
        return VaccineModel.fromJson(data['data'] as Map<String, dynamic>);
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
  Future<VaccineModel> updateVaccinationStatus(
    int childId,
    int id,
    UpdateVaccinationRequestModel body,
  ) async {
    try {
      final response = await _apiClient.put(
        Api.childVaccinationById(childId, id),
        data: body.toJson(),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true && data['data'] != null) {
        return VaccineModel.fromJson(data['data'] as Map<String, dynamic>);
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
  Future<List<VaccineModel>> getUpcomingVaccinations(int childId, int daysAhead) async {
    try {
      final response = await _apiClient.get(
        Api.childUpcomingVaccinations(childId),
        queryParameters: {'daysAhead': daysAhead},
        options: Options(
          headers: {
            ..._headers.headers ?? {},
            'daysAhead': daysAhead.toString(),
          },
        ),
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => VaccineModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
  Future<List<VaccineModel>> getOverdueVaccinations(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childOverdueVaccinations(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => VaccineModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
  Future<List<VaccineModel>> getCompletedVaccinations(int childId) async {
    try {
      final response = await _apiClient.get(
        Api.childCompletedVaccinations(childId),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => VaccineModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
  Future<VaccineModel> markVaccinationAsTaken(
    int childId,
    int id,
    UpdateVaccinationRequestModel body,
  ) async {
    try {
      final response = await _apiClient.put(
        Api.markVaccinationTaken(childId, id),
        data: body.toJson(),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true && data['data'] != null) {
        return VaccineModel.fromJson(data['data'] as Map<String, dynamic>);
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
