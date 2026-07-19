import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';

@lazySingleton
class LanguageCubit extends Cubit<Locale> {
  static const String _langKey = 'selected_language';

  LanguageCubit() : super(const Locale('en'));

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_langKey);
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, languageCode);
    emit(Locale(languageCode));

    try {
      final authLocalDataSource = getIt<AuthLocalDataSource>();
      final tokens = await authLocalDataSource.getTokens();
      if (tokens != null) {
        final apiClient = getIt<ApiClient>();
        await apiClient.put(
          Api.languagePreference,
          data: {'language': languageCode},
        );
      }
    } catch (e) {
      // Fail silently to avoid breaking the local UI language change if the network request fails
    }
  }
}
