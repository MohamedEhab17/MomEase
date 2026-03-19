import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';

Widget buildDrawerIcon(String asset, {Color? color}) {
  return SvgPicture.asset(
    asset,
    width: 20.w,
    height: 20.w,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
  );
}

Widget buildDrawerChevron() {
  return SvgPicture.asset(
    AppIcons.iconsForwardArrow,
    width: 20.w,
    height: 20.w,
    colorFilter: ColorFilter.mode(AppColors.primaryDark, BlendMode.srcIn),
  );
}
