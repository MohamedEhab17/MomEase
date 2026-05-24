import 'package:flutter/material.dart';
import 'package:new_mama/core/utils/app_styles.dart';

import 'app_theme_extension.dart';

class AppTextTheme {
  static TextTheme textTheme(ColorScheme colorScheme, AppThemeExtension ext) {
    return TextTheme(
      displayLarge: AppStyles.styleInter32.copyWith(
        color: ext.colors.lightTextPrimary,
      ),
      displayMedium: AppStyles.styleInter24.copyWith(
        color: ext.colors.lightTextPrimary,
      ),
      displaySmall: AppStyles.styleRoboto24.copyWith(
        color: ext.colors.lightTextPrimary,
      ),

      headlineLarge: AppStyles.styleScriptMT32.copyWith(
        color: ext.colors.primaryDark,
      ),
      headlineMedium: AppStyles.styleRoboto20.copyWith(
        color: ext.colors.lightTextDisabled,
      ),
      headlineSmall: AppStyles.styleInter20.copyWith(
        color: ext.colors.lightTextPrimary,
      ),
      
      titleLarge: AppStyles.styleRoboto16.copyWith(
        color: ext.colors.lightTextSecondary,
      ),
      titleMedium: AppStyles.styleInter16.copyWith(
        color: ext.colors.lightTextPrimary,
      ),
      titleSmall: AppStyles.styleInter14.copyWith(
        color: ext.colors.lightTextPrimary.withAlpha(178),
      ),

      bodyLarge: AppStyles.styleRoboto12.copyWith(
        color: ext.colors.lightTextDisabled,
      ),
      bodyMedium: AppStyles.styleInter12.copyWith(
        color: ext.colors.lightTextPrimary,
      ),
      bodySmall: AppStyles.styleInter10.copyWith(
        color: ext.colors.lightTextPrimary,
      ),

      labelSmall: AppStyles.styleInter8.copyWith(
        color: ext.colors.lightTextDisabled,
      ),
    );
  }
}
