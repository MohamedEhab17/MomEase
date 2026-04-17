import 'package:dio/dio.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import '../../di/injection.dart';
import '../../../feature/auth/data/datasources/auth_local_data_source_contract.dart';
import '../../../feature/auth/data/models/token_model.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final localDataSource = getIt<AuthLocalDataSource>();
    final token = await localDataSource.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final localDataSource = getIt<AuthLocalDataSource>();
      final tokens = await localDataSource.getTokens();

      if (tokens != null && tokens.refreshToken.isNotEmpty) {
        try {
          final newTokens = await _refreshToken(tokens.refreshToken);

          if (newTokens != null) {
            await localDataSource.saveTokens(newTokens);

            // Retry original request with new access token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

            final dio = Dio();
            dio.options.baseUrl = Api.baseUrl;
            final response = await dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (_) {
          // Refresh failed — clear tokens so user is effectively logged out
          await localDataSource.clearAll();
        }
      }
    }
    super.onError(err, handler);
  }

  /// Calls /api/Auth/refresh-token.
  /// Real response: { success, message, data: { userId, firstName, ..., accessToken, refreshToken, accessTokenExpiration, refreshTokenExpiration } }
  Future<TokenModel?> _refreshToken(String refreshToken) async {
    final dio = Dio();
    dio.options.baseUrl = Api.baseUrl;

    try {
      final response = await dio.post(
        Api.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final body = response.data as Map<String, dynamic>;
        final success = body['success'] == true;
        final data = body['data'];

        if (success && data != null && data is Map<String, dynamic>) {
          // data contains accessToken, refreshToken, accessTokenExpiration, refreshTokenExpiration
          if (data.containsKey('accessToken')) {
            return TokenModel.fromJson(data);
          }
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
