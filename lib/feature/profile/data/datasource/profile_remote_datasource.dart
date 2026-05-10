import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_keys.dart';
import '../../../../core/network/api_client.dart';
import '../models/mother_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<MotherProfileModel> getProfile();
  Future<MotherProfileModel> updateProfile(MotherProfileModel profile);
  Future<String> uploadPhoto(String filePath);
  Future<void> deletePhoto();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<MotherProfileModel> getProfile() async {
    final response = await _apiClient.get(Api.motherProfile);
    return MotherProfileModel.fromJson(response.data['data']);
  }

  @override
  Future<MotherProfileModel> updateProfile(MotherProfileModel profile) async {
    final response = await _apiClient.put(
      Api.motherProfile,
      data: profile.toJson(),
    );
    return MotherProfileModel.fromJson(response.data['data']);
  }

  @override
  Future<String> uploadPhoto(String filePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiClient.post(
      '${Api.motherProfile}/photo',
      data: formData,
    );
    return response.data['data']['photoUrl'];
  }

  @override
  Future<void> deletePhoto() async {
    await _apiClient.delete('${Api.motherProfile}/photo');
  }
}
