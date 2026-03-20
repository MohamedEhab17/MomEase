import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class VaccineProgressHeader extends StatelessWidget {
  final int completed;
  final int total;
  final String nextDueDate;
  final int daysUntilDue;

  const VaccineProgressHeader({
    super.key,
    required this.completed,
    required this.total,
    required this.nextDueDate,
    required this.daysUntilDue,
  });

  @override
  Widget build(BuildContext context) {
    final progress = completed / total;
    final percentage = (progress * 100).round();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryExtraLight),
      ),
      child: Row(
        children: [
          // Completed stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed:',
                  style: AppStyles.styleInter12.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$completed/$total',
                      style: AppStyles.styleInter24.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '$percentage%',
                        style: AppStyles.styleInter10.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.h,
                    backgroundColor: AppColors.primaryExtraLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          // Divider
          Container(width: 1, height: 60.h, color: AppColors.primaryExtraLight),
          SizedBox(width: 20.w),
          // Next due
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next Due',
                style: AppStyles.styleInter12.copyWith(
                  color: AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                nextDueDate,
                style: AppStyles.styleInter24.copyWith(
                  color: AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'In $daysUntilDue days',
                style: AppStyles.styleInter12.copyWith(
                  color: AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
