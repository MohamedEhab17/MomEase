import 'package:equatable/equatable.dart';

class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiration;
  final DateTime refreshTokenExpiration;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiration,
    required this.refreshTokenExpiration,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        accessTokenExpiration,
        refreshTokenExpiration,
      ];
}
