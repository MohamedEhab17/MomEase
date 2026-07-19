import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { pink, blue, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  static const String _themeKey = 'selected_theme';

  ThemeCubit() : super(AppThemeMode.pink);

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs.getString(_themeKey);
    if (themeName != null) {
      final themeMode = AppThemeMode.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => AppThemeMode.pink,
      );
      emit(themeMode);
    }
  }

  Future<void> changeTheme(AppThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.name);
    emit(themeMode);
  }

  Future<void> toggleTheme() async {
    AppThemeMode newTheme;
    if (state == AppThemeMode.pink) {
      newTheme = AppThemeMode.blue;
    } else if (state == AppThemeMode.blue) {
      newTheme = AppThemeMode.dark;
    } else {
      newTheme = AppThemeMode.pink;
    }
    await changeTheme(newTheme);
  }
}
