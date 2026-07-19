extension EmailMasking on String {
  String maskEmail() {
    final parts = split('@');
    if (parts.length != 2) return this;

    final name = parts[0];
    final domain = parts[1];

    int startVisible = 1;
    int endVisible = 0;

    if (name.length <= 4) {
      startVisible = 1;
      endVisible = 0;
    } else if (name.length <= 7) {
      startVisible = 2;
      endVisible = 1;
    } else {
      startVisible = 3;
      endVisible = 2;
    }

    final start = name.substring(0, startVisible);
    final end = endVisible > 0 ? name.substring(name.length - endVisible) : '';

    final maskedLength = name.length - (startVisible + endVisible);
    final masked = '•' * (maskedLength > 0 ? maskedLength : 0);

    return '$start$masked$end@$domain';
  }
}
