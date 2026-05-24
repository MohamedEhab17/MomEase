import 'package:flutter/material.dart';
import 'package:new_mama/core/theme/app_colors.dart';
import 'package:new_mama/core/theme/app_theme_extension.dart';
import 'package:new_mama/core/theme/app_text_theme.dart';

class AppTheme {
  // ==========================================
  // PINK THEME (زي ما هو)
  // ==========================================

  static AppThemeExtension pinkExtension = AppThemeExtension(
    colors: AppColors.pink,
  );

  static ThemeData pinkTheme = ThemeData(
    extensions: [pinkExtension],
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.pink.lightBackground,

    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.pink.backgroundPink,
    ),

    cardColor: AppColors.pink.lightBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.pink.lightBackground,
      iconTheme: IconThemeData(color: AppColors.pink.primary),
    ),

    shadowColor: AppColors.pink.lightTextPrimary,

    bannerTheme: MaterialBannerThemeData(
      backgroundColor: AppColors.pink.primaryLighter,
    ),

    iconTheme: IconThemeData(color: AppColors.pink.primary),

    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.pink.primaryDark,
        onPrimary: AppColors.pink.darkTextPrimary,
        secondary: AppColors.pink.lightBackground,
        onSecondary: AppColors.pink.lightTextPrimary,
        tertiary: AppColors.pink.primaryAccent,
        onTertiary: AppColors.pink.darkTextPrimary,
        surface: AppColors.pink.primaryExtraLight,
        onSurface: AppColors.pink.lightTextPrimary,
        onSurfaceVariant: AppColors.pink.greyMedium,
      ),
    ),

    colorScheme: ColorScheme.light(
      primary: AppColors.pink.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.pink.primaryTint,
      onPrimaryContainer: AppColors.pink.lightTextPrimary,
      surface: AppColors.pink.primaryExtraLight,
      onSurface: AppColors.pink.lightTextPrimary,
      onSurfaceVariant: AppColors.pink.lightTextSecondary,
    ),

    textTheme: AppTextTheme.textTheme(
      ColorScheme.light(
        primary: AppColors.pink.primary,
        primaryContainer: AppColors.pink.primaryTint,
        surface: AppColors.pink.primaryExtraLight,
        onPrimary: Colors.white,
        onSurface: AppColors.pink.lightTextPrimary,
        onSurfaceVariant: AppColors.pink.lightTextSecondary,
      ),
      pinkExtension
      
    ),
  );

  // ==========================================

  static AppThemeExtension blueExtension = AppThemeExtension(
    colors: AppColors.blue,
  );

  static ThemeData blueTheme = ThemeData(
    extensions: [blueExtension],
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.blue.lightBackground,

    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.blue.backgroundPink,
    ),

    cardColor: AppColors.blue.lightBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.blue.lightBackground,
      iconTheme: IconThemeData(color: AppColors.blue.primary),
    ),

    shadowColor: AppColors.blue.lightTextPrimary,

    bannerTheme: MaterialBannerThemeData(
      backgroundColor: AppColors.blue.primaryLighter,
    ),

    iconTheme: IconThemeData(color: AppColors.blue.primary),

    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.blue.primaryDark,
        onPrimary: AppColors.blue.darkTextPrimary,
        secondary: AppColors.blue.lightBackground,
        onSecondary: AppColors.blue.lightTextPrimary,
        tertiary: AppColors.blue.primaryAccent,
        onTertiary: AppColors.blue.darkTextPrimary,
        surface: AppColors.blue.primaryExtraLight,
        onSurface: AppColors.blue.lightTextPrimary,
        onSurfaceVariant: AppColors.blue.greyMedium,
      ),
    ),

    colorScheme: ColorScheme.light(
      primary: AppColors.blue.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.blue.primaryTint,
      onPrimaryContainer: AppColors.blue.lightTextPrimary,
      surface: AppColors.blue.primaryExtraLight,
      onSurface: AppColors.blue.lightTextPrimary,
      onSurfaceVariant: AppColors.blue.lightTextSecondary,
    ),

    textTheme: AppTextTheme.textTheme(
      ColorScheme.light(
        primary: AppColors.blue.primary,
        primaryContainer: AppColors.blue.primaryTint,
        surface: AppColors.blue.primaryExtraLight,
        onPrimary: Colors.white,
        onSurface: AppColors.blue.lightTextPrimary,
        onSurfaceVariant: AppColors.blue.lightTextSecondary,
      ),
      blueExtension,
    ),
  );

  // ==========================================

  static AppThemeExtension darkExtension = AppThemeExtension(
    colors: AppColors.dark,
  );

  static ThemeData darkTheme = ThemeData(
    extensions: [darkExtension],
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.lightBackground,

    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.dark.backgroundPink,
    ),

    cardColor: AppColors.dark.primaryBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark.lightBackground,
      iconTheme: IconThemeData(color: AppColors.dark.lightTextPrimary),
    ),

    shadowColor: Colors.black,

    bannerTheme: MaterialBannerThemeData(
      backgroundColor: AppColors.dark.primary,
    ),

    iconTheme: IconThemeData(color: AppColors.dark.lightTextPrimary),

    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(
        primary: AppColors.dark.primary,
        onPrimary: AppColors.dark.darkTextPrimary,
        secondary: AppColors.dark.lightBackground,
        onSecondary: AppColors.dark.lightTextPrimary,
        tertiary: AppColors.dark.primaryAccent,
        onTertiary: AppColors.dark.darkTextPrimary,
        surface: AppColors.dark.primaryExtraLight,
        onSurface: AppColors.dark.lightTextPrimary,
        onSurfaceVariant: AppColors.dark.greyMedium,
      ),
    ),

    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.dark.primaryTint,
      onPrimaryContainer: AppColors.dark.lightTextPrimary,
      surface: AppColors.dark.primaryBackground,
      onSurface: AppColors.dark.lightTextPrimary,
      onSurfaceVariant: AppColors.dark.lightTextSecondary,
    ),

    textTheme: AppTextTheme.textTheme(
      ColorScheme.dark(
        primary: AppColors.dark.primary,
        primaryContainer: AppColors.dark.primaryTint,
        surface: AppColors.dark.primaryBackground,
        onPrimary: Colors.white,
        onSurface: AppColors.dark.lightTextPrimary,
        onSurfaceVariant: AppColors.dark.lightTextSecondary,
      ),
      darkExtension,
    ),
  );
}
