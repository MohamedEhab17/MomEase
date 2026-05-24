import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../network/dio_factory.dart';
import 'package:local_auth/local_auth.dart';

@module
abstract class AppModule {
  @lazySingleton
  AudioRecorder get audioRecorder => AudioRecorder();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  Dio get dio => DioFactory.create();

  @lazySingleton
  ApiClient apiClient(Dio dio) => ApiClient(dio);

  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  LocalAuthentication get localAuth => LocalAuthentication();
}
