import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class InsightSuggestionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const InsightSuggestionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primaryExtraLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.styleInter14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: AppStyles.styleInter12.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  child: Text(
                    'Read more ›',
                    style: AppStyles.styleInter12.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
