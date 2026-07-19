import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/children/data/datasources/children_remote_data_source.dart';
import 'package:new_mama/feature/children/data/models/child_model.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

@LazySingleton(as: ChildrenRemoteDataSource)
class ChildrenRemoteDataSourceImpl implements ChildrenRemoteDataSource {
  final ApiClient _apiClient;

  ChildrenRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ChildModel>> getChildren() async {
    final response = await _apiClient.get(Api.children);
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => ChildModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to get children') : 'Unexpected response',
    );
  }

  @override
  Future<ChildModel> getChild(int childId) async {
    final response = await _apiClient.get(Api.childById(childId));
    return _handleChildResponse(response.data);
  }

  @override
  Future<ChildModel> createChild(CreateChildParams params) async {
    final response = await _apiClient.post(
      Api.children,
      data: params.toJson(),
    );
    return _handleChildResponse(response.data);
  }

  @override
  Future<ChildModel> updateChild(int childId, UpdateChildParams params) async {
    final response = await _apiClient.put(
      Api.childById(childId),
      data: params.toJson(),
    );
    return _handleChildResponse(response.data);
  }

  @override
  Future<String> deleteChild(int childId) async {
    final response = await _apiClient.delete(Api.childById(childId));
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data['message'] as String? ?? 'Child deleted successfully';
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to delete child') : 'Unexpected response',
    );
  }

  @override
  Future<String> uploadPhoto(int childId, File photo) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        photo.path,
        filename: photo.path.split('/').last,
      ),
    });
    final response = await _apiClient.post(
      Api.childPhoto(childId),
      data: formData,
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return (data['data'] as Map<String, dynamic>?)?['photoUrl'] as String? ??
          '';
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to upload photo') : 'Unexpected response',
    );
  }

  @override
  Future<String> deletePhoto(int childId) async {
    final response = await _apiClient.delete(Api.childPhoto(childId));
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data['message'] as String? ?? 'Photo deleted successfully';
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to delete photo') : 'Unexpected response',
    );
  }

  ChildModel _handleChildResponse(dynamic data) {
    if (data is Map<String, dynamic> && data['success'] == true) {
      final childData = data['data'] as Map<String, dynamic>?;
      if (childData != null) return ChildModel.fromJson(childData);
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Invalid response') : 'Unexpected response',
    );
  }
}
