import 'package:new_mama/core/localization/translation_keys.dart';

class LocalizationHelper {
  LocalizationHelper._();

  /// Maps a server severity string (case-insensitive) to a TK constant.
  /// Returns null if no match — callers should fall back to the raw server value.
  static String? mapSeverityToTk(String? severity) {
    if (severity == null) return null;
    
    switch (severity.toLowerCase().trim()) {
      case 'minimal':
        return TK.depressionSeverityMinimal;
      case 'mild':
        return TK.depressionSeverityMild;
      case 'moderate':
        return TK.depressionSeverityModerate;
      case 'moderately severe':
      case 'moderately_severe':
        return TK.depressionSeverityModSevere;
      case 'severe':
        return TK.depressionSeveritySevere;
      default:
        return null;
    }
  }
}
