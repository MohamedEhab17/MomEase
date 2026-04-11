import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class TwoDividerSeparatedWithText extends StatelessWidget {
  const TwoDividerSeparatedWithText({
    super.key,
    required this.text,
    this.width = 125,
    this.color,
  });
  final String text;
  final double width;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: color ?? context.ext.colors
              .lightTextDisabled,
            thickness: 1.w,
            endIndent: 8.w,
            indent: 52.w,
          ),
        ),
        Text(text, style: context.text.bodyMedium),
        Expanded(
          child: Divider(
            color: color ?? context.ext.colors
              .lightTextDisabled,
            thickness: 1.w,
            endIndent: 52.w,
            indent: 8.w,
          ),
        ),
      ],
    );
  }
}
