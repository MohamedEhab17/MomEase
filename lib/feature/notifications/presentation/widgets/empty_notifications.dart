import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.iconsInActiveNotification,
            width: 80.r,
            height: 80.r,
            colorFilter: const ColorFilter.mode(
              AppColors.textDisabledLighter,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'You Don’t have notifications',
            style: AppStyles.styleInter16.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'When you get notifications, they\'ll show up here',
            style: AppStyles.styleInter12.copyWith(
              color: AppColors.lightTextPrimary.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
