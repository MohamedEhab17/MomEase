import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';

class VaccineRecordCard extends StatelessWidget {
  final VaccineRecord record;
  final int animationIndex;

  const VaccineRecordCard({
    super.key,
    required this.record,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = record.status == VaccineStatus.completed;

    return Container(
      margin: 16.bottomPadding,
      padding: 16.allPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightTextPrimary.withAlpha(38),
            blurRadius: 24,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: icon circle
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.backgroundGreen.withAlpha(40)
                  : AppColors.primaryExtraLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted
                  ? Icons.medical_services_rounded
                  : Icons.vaccines_rounded,
              size: 18.sp,
              color: isCompleted ? AppColors.greenText : AppColors.primaryDark,
            ),
          ),
          SizedBox(width: 12.w),
          // Middle: text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: AppStyles.styleInter14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  record.doseInfo,
                  style: AppStyles.styleInter12.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Right: status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.backgroundGreen.withAlpha(40)
                  : AppColors.primaryExtraLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              isCompleted ? 'Completed' : 'Upcoming',
              style: AppStyles.styleInter10.copyWith(
                color: isCompleted
                    ? AppColors.greenText
                    : AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
