import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

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
          color: background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryExtraLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              style: AppStyles.styleInter10.copyWith(
                color: AppColors.lightTextSecondary,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: AppStyles.styleInter10.copyWith(
                color: AppColors.lightTextPrimary,
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
