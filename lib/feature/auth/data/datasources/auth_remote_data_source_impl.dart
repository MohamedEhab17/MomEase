import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_remote_data_source_contract.dart';
import 'package:new_mama/feature/auth/data/models/auth_response_model.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      Api.login,
      data: {'email': email, 'password': password},
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int age,
  }) async {
    final response = await _apiClient.post(
      Api.register,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'phone': phone,
        'age': age,
      },
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> verifyEmail({
    required String email,
    required String otpCode,
  }) async {
    final response = await _apiClient.post(
      Api.verifyEmail,
      data: {'email': email, 'otpCode': otpCode},
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> forgotPassword({required String email}) async {
    final response = await _apiClient.post(
      Api.forgotPassword,
      data: {'email': email},
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) async {
    final response = await _apiClient.post(
      Api.resetPassword,
      data: {'email': email, 'otpCode': otpCode, 'newPassword': newPassword},
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> resendOtp({required String email}) async {
    final response = await _apiClient.post(
      Api.resendOtp,
      data: {'email': email},
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> googleLogin({required String idToken}) async {
    final response = await _apiClient.post(
      Api.googleLogin,
      data: {'idToken': idToken},
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await _apiClient.post(
      Api.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> refreshToken({required String refreshToken}) async {
    final response = await _apiClient.post(
      Api.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    return _handleResponse(response);
  }

  @override
  Future<AuthResponseModel> revokeToken({required String refreshToken}) async {
    final response = await _apiClient.post(
      Api.revokeToken,
      data: {'refreshToken': refreshToken},
    );
    return _handleResponse(response);
  }

  /// Handles the API response by checking if the data is a Map or a String.
  /// This prevents the "type 'String' is not a subtype of Map<String, dynamic>" error
  /// when the server returns a plain string error message instead of JSON.
  AuthResponseModel _handleResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(data);
    } else {
      // If we get here, it means the response was not JSON.
      // This happens during ISP redirections (HTTP hijacking) or severe server errors.
      throw const ServerException(
        'Unexpected response from server. This may be due to a network restriction or ISP redirection.',
      );
    }
  }
}
