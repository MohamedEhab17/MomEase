import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/routers/app_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import '../../di/injection.dart';
import '../../../feature/auth/data/datasources/auth_local_data_source_contract.dart';
import '../../../feature/auth/data/models/token_model.dart';

class AuthInterceptor extends QueuedInterceptor {
  static const _accessTokenBuffer = Duration(minutes: 1);

  /// Prevents multiple concurrent refresh calls.
  Completer<TokenModel?>? _refreshCompleter;

  //  onRequest 

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // 1. Language header
      final langCubit = getIt<LanguageCubit>();
      options.headers['Accept-Language'] = langCubit.state.languageCode;

      // 2. Skip auth header for auth endpoints (login, register, etc.)
      if (_isAuthEndpoint(options.path)) {
        return super.onRequest(options, handler);
      }

      // 3. Read stored tokens
      final localDataSource = getIt<AuthLocalDataSource>();
      final tokens = await localDataSource.getTokens();

      if (tokens == null) {
        return super.onRequest(options, handler);
      }

      // 4. Check if refresh token is expired → force logout
      if (_isExpired(tokens.refreshTokenExpiration)) {
        await _forceLogout(localDataSource);
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
            error: 'Session expired. Please login again.',
          ),
        );
      }

      // 5. Proactively refresh if access token is about to expire
      TokenModel activeTokens = tokens;
      if (_isAboutToExpire(tokens.accessTokenExpiration)) {
        final refreshed = await _doRefresh(tokens.refreshToken, localDataSource);
        if (refreshed != null) {
          activeTokens = refreshed;
        } else {
          // Refresh failed → force logout
          await _forceLogout(localDataSource);
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.cancel,
              error: 'Session expired. Please login again.',
            ),
          );
        }
      }

      // 6. Attach bearer token
      options.headers['Authorization'] = 'Bearer ${activeTokens.accessToken}';
      super.onRequest(options, handler);
    } catch (e) {
      super.onRequest(options, handler);
    }
  }

  //  onError 

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 for non-auth endpoints
    if (err.response?.statusCode != 401 || _isAuthEndpoint(err.requestOptions.path)) {
      return super.onError(err, handler);
    }

    final localDataSource = getIt<AuthLocalDataSource>();
    final tokens = await localDataSource.getTokens();

    if (tokens == null || tokens.refreshToken.isEmpty) {
      await _forceLogout(localDataSource);
      return super.onError(err, handler);
    }

    // If refresh token is expired → force logout
    if (_isExpired(tokens.refreshTokenExpiration)) {
      await _forceLogout(localDataSource);
      return super.onError(err, handler);
    }

    // Attempt refresh
    final newTokens = await _doRefresh(tokens.refreshToken, localDataSource);
    if (newTokens == null) {
      await _forceLogout(localDataSource);
      return super.onError(err, handler);
    }

    // Retry the original request with the new access token
    try {
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

      final dio = Dio(BaseOptions(baseUrl: Api.baseUrl));
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } catch (_) {
      return super.onError(err, handler);
    }
  }

  //  Private Helpers 

  /// Returns `true` if [expiration] is in the past.
  bool _isExpired(DateTime expiration) {
    return DateTime.now().isAfter(expiration);
  }

  /// Returns `true` if [expiration] is within the [_accessTokenBuffer] window.
  bool _isAboutToExpire(DateTime expiration) {
    return DateTime.now().isAfter(
      expiration.subtract(_accessTokenBuffer),
    );
  }

  /// Returns `true` for auth-related endpoints that should NOT carry / refresh tokens.
  bool _isAuthEndpoint(String path) {
    const authPaths = [
      Api.login,
      Api.register,
      Api.verifyEmail,
      Api.forgotPassword,
      Api.resetPassword,
      Api.resendOtp,
      Api.googleLogin,
      Api.refreshToken,
    ];
    return authPaths.any((p) => path.contains(p));
  }

  /// Deduplicates concurrent refresh calls using a [Completer].
  Future<TokenModel?> _doRefresh(
    String refreshToken,
    AuthLocalDataSource localDataSource,
  ) async {
    // If a refresh is already in progress, wait for it
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<TokenModel?>();

    try {
      final result = await _callRefreshApi(refreshToken);
      if (result != null) {
        await localDataSource.saveTokens(result);
      }
      _refreshCompleter!.complete(result);
      return result;
    } catch (e) {
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// Calls the refresh-token API on a fresh Dio instance (no interceptors).
  Future<TokenModel?> _callRefreshApi(String refreshToken) async {
    final dio = Dio(BaseOptions(baseUrl: Api.baseUrl));

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
          if (data.containsKey('accessToken')) {
            return TokenModel.fromJson(data);
          }
        }
      }
    } catch (e) {
      debugPrint('AuthInterceptor: refresh token API call failed — $e');
    }
    return null;
  }

  /// Clears all local auth data and navigates to the login screen.
  Future<void> _forceLogout(AuthLocalDataSource localDataSource) async {
    await localDataSource.clearAll();
    // Navigate to login and clear the entire navigation stack
    // Wrap in microtask to avoid issues during Dio request lifecycle
    Future.microtask(() => AppRouter.router.go(AppRoutesPaths.login));
  }
}
