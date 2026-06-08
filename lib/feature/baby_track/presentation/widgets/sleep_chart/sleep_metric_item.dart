import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class SleepMetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const SleepMetricItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    return Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: color.withValues(alpha: 20),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        10.w.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.text.bodySmall!.copyWith(
                  fontSize: 10.sp,
                  color: colors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              2.h.height,
              Text(
                value,
                style: context.text.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
