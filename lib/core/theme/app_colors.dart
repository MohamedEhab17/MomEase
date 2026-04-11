import 'package:flutter/material.dart';

class AppColors {
  // Brand
  final Color primaryDark;
  final Color primary;
  final Color primaryLighter;
  final Color primaryAccent;
  final Color primaryTint;
  final Color primaryExtraLight;
  final Color primaryBackground;
  final Color primaryLight;

  // Greys
  final Color greyPrimary;
  final Color greyLight;
  final Color greyExtraLight;
  final Color greyMedium;

  // Functional
  final Color mentionBlue;
  final Color lighterBorder;

  // Accent
  final Color accent;
  final Color accentSoft;

  // Backgrounds
  final Color lightBackground;
  final Color backgroundPink;
  final Color darkBackground;
  final Color backgroundGreen;
  final Color backgroundBlue;
  final Color backgroundBlueDarker;

  // Text
  final Color lightTextPrimary;
  final Color lightTextSecondary;
  final Color lightTextDisabled;
  final Color textDisabledLighter;
  final Color greenText;

  final Color darkTextPrimary;
  final Color darkTextSecondary;

  const AppColors({
    required this.primaryDark,
    required this.primary,
    required this.primaryLighter,
    required this.primaryAccent,
    required this.primaryTint,
    required this.primaryExtraLight,
    required this.primaryBackground,
    required this.primaryLight,
    required this.greyPrimary,
    required this.greyLight,
    required this.greyExtraLight,
    required this.greyMedium,
    required this.mentionBlue,
    required this.lighterBorder,
    required this.accent,
    required this.accentSoft,
    required this.lightBackground,
    required this.backgroundPink,
    required this.darkBackground,
    required this.backgroundGreen,
    required this.backgroundBlue,
    required this.backgroundBlueDarker,
    required this.lightTextPrimary,
    required this.lightTextSecondary,
    required this.lightTextDisabled,
    required this.textDisabledLighter,
    required this.greenText,
    required this.darkTextPrimary,
    required this.darkTextSecondary,
  });

  /// 💗 Pink Colors
  static const AppColors pink = AppColors(
    primaryDark: Color(0xFFFF3381),
    primary: Color(0xFFFF66A1),
    primaryLighter: Color(0xffFFC8DD),
    primaryAccent: Color(0xffFF8CB8),
    primaryTint: Color(0xFFFFF0F6),
    primaryExtraLight: Color(0xFFFFE5EF),
    primaryBackground: Color(0xFFFFEFF5),
    primaryLight: Color(0xFFFF9BBC),
    greyPrimary: Color(0xff9E9E9E),
    greyLight: Color(0xffCECECE),
    greyExtraLight: Color(0xFFE0E0E0),
    greyMedium: Color(0xFFC7C7C7),
    mentionBlue: Color(0xFF1877F2),
    lighterBorder: Color(0xFFFDF2F8),
    accent: Color(0xFFA2D2FF),
    accentSoft: Color(0xFFCCE6FF),
    lightBackground: Color(0xFFFFFFFF),
    backgroundPink: Color(0xffFFF4F8),
    darkBackground: Color(0xFF121212),
    backgroundGreen: Color(0xFF92E3A9),
    backgroundBlue: Color(0xFFA2D2FF),
    backgroundBlueDarker: Color(0xFF76B4EB),
    lightTextPrimary: Color(0xFF000000),
    lightTextSecondary: Color(0xFF9E9E9E),
    lightTextDisabled: Color(0xFF999999),
    textDisabledLighter: Color(0xffB2B2B2),
    greenText: Color(0xFF31B042),
    darkTextPrimary: Color(0xFFFFFFFF),
    darkTextSecondary: Color(0xFFCECECE),
  );

  /// 💙 Blue Colors
  static const AppColors blue = AppColors(
    primaryDark: Color(0xFF2F6FE4),
    primary: Color(0xFF4C8DFF),
    primaryLighter: Color(0xFFCFE0FF),
    primaryAccent: Color(0xFF7AAEFF),

    primaryTint: Color(0xFFEAF2FF),
    primaryExtraLight: Color(0xFFF5F8FF),
    primaryBackground: Color(0xFFEFF5FF),
    primaryLight: Color(0xFF9BBCFF),

    greyPrimary: Color(0xff9E9E9E),
    greyLight: Color(0xffCECECE),
    greyExtraLight: Color(0xFFE0E0E0),
    greyMedium: Color(0xFFC7C7C7),

    mentionBlue: Color(0xFF1877F2),

    lighterBorder: Color(0xFFE3ECFF),

    accent: Color(0xFFA2D2FF),
    accentSoft: Color(0xFFCCE6FF),

    lightBackground: Color(0xFFFFFFFF),
    backgroundPink: Color(0xFFF4F8FF),
    darkBackground: Color(0xFF121212),

    backgroundGreen: Color(0xFF92E3A9),
    backgroundBlue: Color(0xFFA2D2FF),
    backgroundBlueDarker: Color(0xFF76B4EB),

    lightTextPrimary: Color(0xFF1A1A1A),
    lightTextSecondary: Color(0xFF6B7280),
    lightTextDisabled: Color(0xFF9CA3AF),
    textDisabledLighter: Color(0xFFB2B2B2),

    greenText: Color(0xFF31B042),

    darkTextPrimary: Color(0xFFFFFFFF),
    darkTextSecondary: Color(0xFFCECECE),
  );

  /// 🌙 Dark Colors
  // static const AppColors dark = AppColors(
  //   primaryDark: Color(0xFF454B58),
  //   primary: Color(0xFF555D6D),
  //   primaryLighter: Color(0xFF6A7385),
  //   primaryAccent: Color(0xFF7F8AA0),

  //   primaryTint: Color(0xFF1A1F2A),
  //   primaryExtraLight: Color(0xFF232A36),
  //   primaryBackground: Color(0xFF0F1115),
  //   primaryLight: Color(0xFF9AA6BA),

  //   greyPrimary: Color(0xFFC2C8D4),
  //   greyLight: Color(0xFFADB6C6),
  //   greyExtraLight: Color(0xFF353C4A),
  //   greyMedium: Color(0xFF7E8899),

  //   mentionBlue: Color(0xFF4C8DFF),

  //   lighterBorder: Color(0xFF343C4C),

  //   accent: Color(0xFF4C8DFF),
  //   accentSoft: Color(0xFF222B3A),

  //   lightBackground: Color(0xFF0F1115),
  //   backgroundPink: Color(0xFF161B24),
  //   darkBackground: Color(0xFF0A0C10),

  //   backgroundGreen: Color(0xFF1F3D2B),
  //   backgroundBlue: Color(0xFF1C2A3A),
  //   backgroundBlueDarker: Color(0xFF111827),

  //   lightTextPrimary: Color(0xFFE8ECF5),
  //   lightTextSecondary: Color(0xFFB8C1D1),
  //   lightTextDisabled: Color(0xFF7A8495),
  //   textDisabledLighter: Color(0xFF5A6475),

  //   greenText: Color(0xFF4CAF50),

  //   darkTextPrimary: Color(0xFFFFFFFF),
  //   darkTextSecondary: Color(0xFFCECECE),
  // );
  static const AppColors dark = AppColors(
    // 1. Primary Colors
    primaryDark: Color(0xFF6B7A99),
    primary: Color(0xFF8DA4C8),
    primaryLighter: Color(0xFFA9BEE0),
    primaryAccent: Color(0xFFC4D6F2),

    // Surface & Background Colors
    primaryTint: Color(0xFF1E2532),
    primaryExtraLight: Color(0xFF2A3446),
    primaryBackground: Color(0xFF0D1017),
    primaryLight: Color(0xFFD6E3F8),

    // 2. Greys
    greyPrimary: Color(0xFFE2E8F0),
    greyLight: Color(0xFFCBD5E1),
    greyMedium: Color(0xFF94A3B8),
    greyExtraLight: Color(0xFF475569),

    mentionBlue: Color(0xFF60A5FA),

    lighterBorder: Color(0xFF334155),

    accent: Color(0xFF60A5FA),
    accentSoft: Color(0xFF1E293B),

    // 3. Environment Backgrounds
    lightBackground: Color(0xFF151923),
    backgroundPink: Color(0xFF1F2937),
    backgroundGreen: Color(0xFF142C1F),
    backgroundBlue: Color(0xFF162438),
    backgroundBlueDarker: Color(0xFF0B121F),
    darkBackground: Color(0xFF07090C),
    // 4. Text Colors
    lightTextPrimary: Color(0xFFF8FAFC),
    lightTextSecondary: Color(0xFFCBD5E1),
    lightTextDisabled: Color(0xFF64748B),
    textDisabledLighter: Color(0xFF475569),

    greenText: Color(0xFF4ADE80),

    darkTextPrimary: Color(0xFFFFFFFF),
    darkTextSecondary: Color(0xFFE2E8F0),
  );
}
