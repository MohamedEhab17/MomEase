import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class SleepStatLabel extends StatelessWidget {
  final String label;
  final String value;

  const SleepStatLabel({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.bodySmall!.copyWith(
            fontSize: 9.sp,
            color: colors.lightTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        4.h.height,
        Text(
          value,
          style: context.text.bodyMedium!.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
