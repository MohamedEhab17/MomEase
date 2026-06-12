/// Utilities for resolving child photo URLs safely throughout the application.
///
/// The backend may return either:
/// - A fully-qualified URL: `https://...` (pass-through as-is)
/// - A relative path:       `/uploads/children/abc.jpg` (prefixed with base URL)
/// - An empty string or null (returns empty string — treat as "no photo")
abstract class ChildImageHelper {
  static const String _baseUrl = 'http://momease.runasp.net';

  /// Resolves a raw [photoUrl] from the API into a ready-to-use absolute URL.
  ///
  /// - Returns an empty string when [photoUrl] is null or blank.
  /// - Passes through URLs that already start with `http`.
  /// - Prepends [_baseUrl] to relative paths (e.g. `/uploads/children/abc.jpg`).
  static String getChildImageUrl(String? photoUrl) {
    if (photoUrl == null || photoUrl.trim().isEmpty) return '';

    if (photoUrl.startsWith('http')) return photoUrl;

    return '$_baseUrl$photoUrl';
  }

  /// Returns `true` when [photoUrl] resolves to a usable network URL.
  static bool hasPhoto(String? photoUrl) => getChildImageUrl(photoUrl).isNotEmpty;
}
