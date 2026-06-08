import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

/// Extension on a raw sleep status string (e.g. 'good', 'normal', 'poor').
///
/// Centralises all status → UI mapping so it is never repeated across widgets.
/// Mirrors the pattern established by [FeedingStatusExtension].
extension SleepStatusExtension on String {
  /// Foreground / indicator colour for this status.
  Color statusColor(BuildContext context) {
    final colors = context.ext.colors;
    switch (toLowerCase()) {
      case 'good':
        return colors.severityMinimal;
      case 'normal':
        return colors.severityMild;
      case 'poor':
        return colors.severityHigh;
      default:
        return colors.lightTextDisabled;
    }
  }

  /// Soft background colour for this status (used in badges / card backgrounds).
  Color statusBgColor(BuildContext context) {
    final colors = context.ext.colors;
    switch (toLowerCase()) {
      case 'good':
        return colors.severityMinimalBg;
      case 'normal':
        return colors.severityMildBg;
      case 'poor':
        return colors.severityHighBg;
      default:
        return colors.primaryLighter.withValues(alpha: 20);
    }
  }

  /// Localised human-readable label for this status.
  String statusLabel(BuildContext context) {
    switch (toLowerCase()) {
      case 'good':
        return context.trContext(TK.babySleepStatusGood);
      case 'normal':
        return context.trContext(TK.babySleepStatusNormal);
      case 'poor':
        return context.trContext(TK.babySleepStatusPoor);
      default:
        return context.trContext(TK.babySleepStatusUnknown);
    }
  }
}
