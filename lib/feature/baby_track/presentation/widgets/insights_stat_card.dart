import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

/// A small stat card used in the top row of the Insights tab.
class InsightsStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color background;
  final String label;
  final String value;

  const InsightsStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: background.withAlpha(70),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: background),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              style: context.text.bodyMedium!,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: context.text.bodySmall!.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
