import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int age,
  });

  Future<AuthResponseModel> verifyEmail({
    required String email,
    required String otpCode,
  });

  Future<AuthResponseModel> forgotPassword({
    required String email,
  });

  Future<AuthResponseModel> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  });

  Future<AuthResponseModel> resendOtp({
    required String email,
  });

  Future<AuthResponseModel> googleLogin({
    required String idToken,
  });

  Future<AuthResponseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  });

  Future<AuthResponseModel> revokeToken({
    required String refreshToken,
  });
}

