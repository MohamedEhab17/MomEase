import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primarySoft2,
      surface: AppColors.primarySoft3,
      onPrimary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
    ),

    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: AppColors.lightBorder.withAlpha(77),
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(16),
    //     borderSide: BorderSide.none,
    //   ),
    // ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      // surface: AppColors.darkSurface,
    ),
  );
}
