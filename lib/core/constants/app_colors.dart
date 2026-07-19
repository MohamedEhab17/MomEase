import 'package:flutter/material.dart';

/// Compatibility shim for chatbot feature.
/// The rest of the app uses [AppThemeExtension] via context.ext.colors,
/// but the chatbot widgets were written against static color constants.
/// This file re-exports the pink (default) palette as static constants
/// so the chatbot files compile without changes to their color logic.
abstract class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFFF66A1);
  static const Color primaryDark = Color(0xFFFF3381);
  static const Color primarySoft = Color(0xFFFF9BBC); // primaryLight
  static const Color primarySoft2 = Color(0xFFFFE5EF); // primaryExtraLight
  static const Color primarySoft3 = Color(0xFFFFF0F6); // primaryTint
  static const Color primaryLighter = Color(0xffFFC8DD);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color backgroundPink = Color(0xffFFF4F8);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF9E9E9E);
  static const Color lightTextDisabled = Color(0xFF999999);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFCECECE);

  // ── Greys ────────────────────────────────────────────────────────────────
  static const Color greyPrimary = Color(0xff9E9E9E);
  static const Color greyLight = Color(0xffCECECE);
  static const Color greyExtraLight = Color(0xFFE0E0E0);
}
