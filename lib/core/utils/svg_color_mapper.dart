import 'dart:ui';

import 'package:flutter_svg/svg.dart';

class AppSvgColorMapper extends ColorMapper {
  final Color from;
  final Color to;

  const AppSvgColorMapper({required this.from, required this.to});

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (color == from) {
      return to;
    }
    return color;
  }
}
