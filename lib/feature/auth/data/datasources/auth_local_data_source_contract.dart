
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<void> saveTokens(TokenModel tokens);
  Future<UserModel?> getUser();
  Future<TokenModel?> getTokens();
  Future<String?> getAccessToken();
  Future<void> setOnboardingCompleted();
  bool isOnboardingCompleted();
  Future<void> clearAll();
}

