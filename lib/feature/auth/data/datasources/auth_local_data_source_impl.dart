import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/helper/secure_storage_helper.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:new_mama/feature/auth/data/models/token_model.dart';
import 'package:new_mama/feature/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPrefs;
  final SecureStorageHelper _secureStorageHelper;

  static const String _userKey = 'cached_user';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accessTokenExpireKey = 'access_token_expire';
  static const String _refreshTokenExpireKey = 'refresh_token_expire';
  static const String _onboardingKey = 'onboarding_completed';

  AuthLocalDataSourceImpl(this._sharedPrefs, this._secureStorageHelper);

  @override
  Future<void> setOnboardingCompleted() async {
    await _sharedPrefs.setBool(_onboardingKey, true);
  }

  @override
  bool isOnboardingCompleted() {
    return _sharedPrefs.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _sharedPrefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> saveTokens(TokenModel tokens) async {
    await _secureStorageHelper.write(_accessTokenKey, tokens.accessToken);
    await _secureStorageHelper.write(_refreshTokenKey, tokens.refreshToken);
    await _sharedPrefs.setString(_accessTokenExpireKey, tokens.accessTokenExpiration.toIso8601String());
    await _sharedPrefs.setString(_refreshTokenExpireKey, tokens.refreshTokenExpiration.toIso8601String());
  }

  @override
  Future<UserModel?> getUser() async {
    final userStr = _sharedPrefs.getString(_userKey);
    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  @override
  Future<TokenModel?> getTokens() async {
    final accessToken = await _secureStorageHelper.read(_accessTokenKey);
    final refreshToken = await _secureStorageHelper.read(_refreshTokenKey);
    final accessExpireStr = _sharedPrefs.getString(_accessTokenExpireKey);
    final refreshExpireStr = _sharedPrefs.getString(_refreshTokenExpireKey);

    if (accessToken != null && refreshToken != null && accessExpireStr != null && refreshExpireStr != null) {
      return TokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessTokenExpiration: DateTime.parse(accessExpireStr),
        refreshTokenExpiration: DateTime.parse(refreshExpireStr),
      );
    }
    return null;
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorageHelper.read(_accessTokenKey);
  }

  @override
  Future<void> clearAll() async {
    await _sharedPrefs.remove(_userKey);
    await _sharedPrefs.remove(_accessTokenExpireKey);
    await _sharedPrefs.remove(_refreshTokenExpireKey);
    await _secureStorageHelper.deleteAll();
  }
}
