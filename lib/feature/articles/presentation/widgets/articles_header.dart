import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ArticlesHeader extends StatelessWidget implements PreferredSizeWidget {
  const ArticlesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      actionsPadding: EdgeInsets.only(right: 15.w),
      actions: [
        SvgPicture.asset(AppIcons.saveFilled, width: 12.w, height: 18.h),
      ],
      centerTitle: true,
      backgroundColor: AppColors.lightBackground,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primaryHard,
          size: 20.sp,
        ),
      ),
      title: Text(
        'Articles',
        style: AppStyles.styleInter20.copyWith(
          color: AppColors.primaryHard,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
