import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

extension DateTimeExtension on DateTime {
  String toRelativeTime(BuildContext context) {
    final d = DateTime.now().difference(this);
    final isAr = context.isAr;
    
    if (d.inSeconds < 60) {
      return context.trContext(TK.communityJustNow);
    } else if (d.inMinutes < 60) {
      return isAr ? "${d.inMinutes} دقيقة" : "${d.inMinutes}m ago";
    } else if (d.inHours < 24) {
      return isAr ? "${d.inHours} ساعة" : "${d.inHours}h ago";
    } else if (d.inDays < 7) {
      return isAr ? "${d.inDays} يوم" : "${d.inDays}d ago";
    }
    return '${day}/${month}/${year}';
  }

  /// Normalizes UTC-shifted DateTimes from DateTime.parse() back to their original calendar day
  DateTime get toCalendarDate {
    if (!isUtc) return this;
    if (hour >= 12) {
      final nextDay = add(const Duration(hours: 12));
      return DateTime(nextDay.year, nextDay.month, nextDay.day);
    } else {
      return DateTime(year, month, day);
    }
  }

  /// Returns localized short weekday name using translation keys
  String getLocalizedDayName(BuildContext context) {
    final safeDate = toCalendarDate;
    const weekdayKeys = {
      1: TK.commonDayMon,
      2: TK.commonDayTue,
      3: TK.commonDayWed,
      4: TK.commonDayThu,
      5: TK.commonDayFri,
      6: TK.commonDaySat,
      7: TK.commonDaySun,
    };
    final key = weekdayKeys[safeDate.weekday] ?? TK.commonDayMon;
    return context.trContext(key);
  }

  /// Formats date to localized "d MMM" using the intl package and EasyLocalization locale
  String formatChartDate(BuildContext context) {
    final safeDate = toCalendarDate;
    final locale = context.locale.languageCode;
    return intl.DateFormat('d MMM', locale).format(safeDate);
  }

  /// Formats date range using the intl package and EasyLocalization locale
  String formatChartDateRange(BuildContext context, DateTime end) {
    final safeStart = toCalendarDate;
    final safeEnd = end.toCalendarDate;
    final locale = context.locale.languageCode;
    final startStr = intl.DateFormat('d MMM', locale).format(safeStart);
    final endStr = intl.DateFormat('d MMM', locale).format(safeEnd);
    return '$startStr - $endStr';
  }
}
