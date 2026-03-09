import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class FeaturesHeader extends StatelessWidget implements PreferredSizeWidget {
  const FeaturesHeader({super.key, required this.title, this.onPressed});
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.lightBackground,
      title: Text(
        title,
        style: AppStyles.styleInter20.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: onPressed ?? () {
          context.pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 24.sp,
          color: AppColors.primaryDark,
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint.withAlpha(128),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTint,
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: SvgPicture.asset(AppIcons.iconsLuna),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
