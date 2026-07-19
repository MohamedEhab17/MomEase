import 'token_model.dart';
import 'user_model.dart';

class AuthResponseModel {
  final bool success;
  final String message;
  final AuthDataModel? data;

  AuthResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] != null && json['data'] is Map<String, dynamic>) 
          ? AuthDataModel.fromJson(json['data']) 
          : null,
    );
  }
}

class AuthDataModel {
  final UserModel? user;
  final TokenModel? tokens;
  final String? resetToken;

  AuthDataModel({
    this.user,
    this.tokens,
    this.resetToken,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    if (json.containsKey('email') || json.containsKey('userId')) {
      user = UserModel.fromJson(json);
    }
    
    TokenModel? tokens;
    if (json.containsKey('accessToken') && json['accessToken'] != null) {
      tokens = TokenModel.fromJson(json);
    }

    String? resetToken = json['resetToken']?.toString();

    return AuthDataModel(
      user: user,
      tokens: tokens,
      resetToken: resetToken,
    );
  }
}
