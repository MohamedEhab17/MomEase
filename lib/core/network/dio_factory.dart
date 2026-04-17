import 'package:dio/dio.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'interceptors/auth_interceptor.dart';

class DioFactory {
  static Dio create() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      followRedirects: true,
      validateStatus: (status) {
        return status! < 500;
      },
    );

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}
