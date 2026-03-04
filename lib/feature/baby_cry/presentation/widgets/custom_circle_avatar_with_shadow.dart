
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class CustomCircleAvatarWithShadow extends StatelessWidget {
  const CustomCircleAvatarWithShadow({
    super.key, this.onTap,
  });
final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primarySoft),
          boxShadow: [
            BoxShadow(
              color: AppColors.primarySoft,
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        // height: 80.h,
        // width: 80.w,
        child: SvgPicture.asset(
          AppIcons.iconsMic,
          height: 39.h,
          width: 35.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
