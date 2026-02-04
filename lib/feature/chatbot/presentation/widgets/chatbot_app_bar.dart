import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ChatbotAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatbotAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.lightTextPrimary.withAlpha(38),
            blurRadius: 15,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: AppColors.lightBackground,
        leadingWidth: 24.w,
        scrolledUnderElevation: 0,
        elevation: 0,
        clipBehavior: Clip.none,
        title: Row(
          mainAxisAlignment: .start,
          spacing: 12,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withAlpha(51),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.transparent, width: 1.w),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primarySoft,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                AppIcons.iconsLuna,
                width: 34.w,
                height: 34.h,
              ),
            ),
            //icon
            Column(
              crossAxisAlignment: .start,
              spacing: 4.h,
              children: [
                Text('Luna AI Assistant', style: AppStyles.styleInter16),
                Text('Ask anything you want', style: AppStyles.styleInter10),
              ],
            ),
          ],
        ),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.lightTextPrimary,
            size: 24.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 65.h);
}
