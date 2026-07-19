import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

/// Extension on a raw feeding status string (e.g. 'normal', 'over', 'under').
/// Centralises all status → UI mapping so it is never repeated across widgets.
extension FeedingStatusExtension on String {
  /// Foreground / indicator colour for this status.
  Color statusColor(BuildContext context) {
    final colors = context.ext.colors;
    switch (toLowerCase()) {
      case 'severeunder':
        return colors.severitySevere;
      case 'under':
        return colors.severityModerate;
      case 'normal':
        return colors.severityMinimal;
      case 'over':
      default:
        return colors.severityHigh;
    }
  }

  /// Soft background colour for this status (used in badges / card backgrounds).
  Color statusBgColor(BuildContext context) {
    final colors = context.ext.colors;
    switch (toLowerCase()) {
      case 'severeunder':
        return colors.severitySevereBg;
      case 'under':
        return colors.severityModerateBg;
      case 'normal':
        return colors.severityMinimalBg;
      case 'over':
      default:
        return colors.severityHighBg;
    }
  }

  /// Localised human-readable label for this status.
  String statusLabel(BuildContext context) {
    switch (toLowerCase()) {
      case 'severeunder':
        return context.trContext(TK.babyFeedingSevereUnder);
      case 'under':
        return context.trContext(TK.babyFeedingUnder);
      case 'normal':
        return context.trContext(TK.babyFeedingNormal);
      case 'over':
        return context.trContext(TK.babyFeedingOver);
      default:
        return this;
    }
  }
}
