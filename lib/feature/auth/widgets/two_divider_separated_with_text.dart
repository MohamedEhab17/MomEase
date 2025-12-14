import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class TwoDividerSeparatedWithText extends StatelessWidget {
  const TwoDividerSeparatedWithText({
    super.key,
    required this.text,
    this.width = 125,
    this.color = AppColors.lightTextDisabled,
  });
  final String text;
  final double width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: color,
            thickness: 1.w,
            endIndent: 8.w,
            indent: 52.w,
          ),
        ),
        Text(text, style: AppStyles.styleRoboto12),
        Expanded(
          child: Divider(
            color: color,
            thickness: 1.w,
            endIndent: 52.w,
            indent: 8.w,
          ),
        ),
      ],
    );
  }
}
