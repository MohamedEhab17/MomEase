import 'package:flutter/material.dart';
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
}
