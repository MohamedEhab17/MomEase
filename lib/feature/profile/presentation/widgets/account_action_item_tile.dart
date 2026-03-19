import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class AccountActionItemTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String? trailingText;
  final VoidCallback? onTap;

  const AccountActionItemTile({
    super.key,
    required this.title,
    required this.iconData,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        padding: 16.w.allPadding,
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lighterBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            12.width,
            Expanded(
              child: Text(
                title,
                style: AppStyles.styleInter14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary.withAlpha(200),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: AppStyles.styleInter12.copyWith(
                  color: AppColors.lightTextSecondary,
                ),
              ),
              8.width,
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.lightTextSecondary.withAlpha(150),
            ),
          ],
        ),
      ),
    );
  }
}
