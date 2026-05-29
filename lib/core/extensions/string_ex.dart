extension StringExtension on String {
  bool get isArabic {
    if (trim().isEmpty) return false;
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    final englishRegex = RegExp(r'[A-Za-z]');
    int arabicCount = arabicRegex.allMatches(this).length;
    int englishCount = englishRegex.allMatches(this).length;
    return arabicCount > englishCount;
  }
}
