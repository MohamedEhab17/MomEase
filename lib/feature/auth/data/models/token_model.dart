import '../../domain/entities/auth_tokens.dart';

class TokenModel extends AuthTokens {
  const TokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.accessTokenExpiration,
    required super.refreshTokenExpiration,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      accessTokenExpiration: DateTime.parse(json['accessTokenExpiration']),
      refreshTokenExpiration: DateTime.parse(json['refreshTokenExpiration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessTokenExpiration': accessTokenExpiration.toIso8601String(),
      'refreshTokenExpiration': refreshTokenExpiration.toIso8601String(),
    };
  }
}
