import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/di/injection.dart';

import 'package:new_mama/feature/baby_track/data/datasources/feeding_remote_data_source_contract.dart';
import 'package:new_mama/feature/baby_track/data/models/feeding_record_model.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';

@LazySingleton(as: FeedingRemoteDataSourceContract)
class FeedingRemoteDataSourceImpl implements FeedingRemoteDataSourceContract {
  final ApiClient _apiClient;

  FeedingRemoteDataSourceImpl(this._apiClient);

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
  Future<FeedingRecordModel> addFeedingRecord(
    int childId,
    AddFeedingRecordRequestModel body,
  ) async {
    try {
      final response = await _apiClient.post(
        Api.childFeedingRecords(childId),
        data: body.toJson(),
        options: _headers,
      );
      final data = _normalizeData(response.data);

      if (data is Map<String, dynamic> && data['success'] == true && data['data'] != null) {
        return FeedingRecordModel.fromJson(data['data'] as Map<String, dynamic>);
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
