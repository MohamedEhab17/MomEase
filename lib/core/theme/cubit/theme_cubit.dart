import 'package:flutter_bloc/flutter_bloc.dart';

enum AppThemeMode { pink, blue, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.pink);

  void changeTheme(AppThemeMode themeMode) {
    emit(themeMode);
  }

  void toggleTheme() {
    if (state == AppThemeMode.pink) {
      emit(AppThemeMode.blue);
    } else if (state == AppThemeMode.blue) {
      emit(AppThemeMode.dark);
    } else {
      emit(AppThemeMode.pink);
    }
  }
}
