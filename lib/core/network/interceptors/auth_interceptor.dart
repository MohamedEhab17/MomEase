import 'package:dio/dio.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import '../../di/injection.dart';
import '../../../feature/auth/data/datasources/auth_local_data_source_contract.dart';
import '../../../feature/auth/data/models/token_model.dart';
import '../../localization/cubit/language_cubit.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final localDataSource = getIt<AuthLocalDataSource>();
    final token = await localDataSource.getAccessToken();

    // 1. Authorization Header
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 2. Accept-Language Header
    if (!options.headers.containsKey('Accept-Language')) {
      options.headers['Accept-Language'] =
          getIt<LanguageCubit>().state.languageCode;
    }

    // 3. Content-Type Header
    options.headers['Content-Type'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Prevent infinite loops:
      // Skip refresh if the request failing is already a refresh token request
      if (err.requestOptions.path.contains(Api.refreshToken)) {
        return handler.next(err);
      }

      // Skip refresh if we've already retried this request once
      if (err.requestOptions.extra['is_retry'] == true) {
        return handler.next(err);
      }

      final localDataSource = getIt<AuthLocalDataSource>();
      final tokens = await localDataSource.getTokens();

      if (tokens != null && tokens.refreshToken.isNotEmpty) {
        try {
          final newTokens = await _refreshToken(tokens.refreshToken);

          if (newTokens != null) {
            await localDataSource.saveTokens(newTokens);

            // Retry original request with new access token
            final options = err.requestOptions;
            options.headers['Authorization'] =
                'Bearer ${newTokens.accessToken}';

            // Mark as retry to prevent infinite loops if it fails again
            options.extra['is_retry'] = true;

            // Reuse SAME Dio instance
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (_) {
          // Refresh failed — clear tokens so user is effectively logged out
          await localDataSource.clearAll();
        }
      }
    }
    return handler.next(err);
  }

  /// Calls /api/Auth/refresh-token using the SAME Dio instance
  Future<TokenModel?> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        Api.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final body = response.data as Map<String, dynamic>;
        final success = body['success'] == true;
        final data = body['data'];

        if (success && data != null && data is Map<String, dynamic>) {
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
