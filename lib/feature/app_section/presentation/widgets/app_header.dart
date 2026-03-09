import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.onMenuPressed});
  final VoidCallback? onMenuPressed;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.lightBackground,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColors.primaryDark),
        onPressed: () => Scaffold.of(context).openDrawer(),
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
      title: Text(
        'MomEase',
        style: AppStyles.styleScriptMT32.copyWith(
          fontSize: 24.sp,
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60.h);
}
