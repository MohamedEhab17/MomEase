import 'package:flutter/material.dart';
import 'package:new_mama/core/theme/app_theme_extension.dart';

extension ThemeEx on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
  AppThemeExtension get ext => theme.extension<AppThemeExtension>()!;
}
