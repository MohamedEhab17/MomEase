import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

extension LocalizationExtension on BuildContext {
  String trContext(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    return tr(key, args: args, namedArgs: namedArgs);
  }
}
