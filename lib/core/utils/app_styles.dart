import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/constants/app_font_family.dart';

abstract class AppStyles {
  //! roboto
  static TextStyle styleRoboto24 = TextStyle(
    fontSize: 24.sp,
    fontFamily: AppFontFamily.roboto,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
  );
  static TextStyle styleRoboto16 = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFontFamily.roboto,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTextSecondary,
  );
  //! inter
  static TextStyle styleInter20 = TextStyle(
    fontSize: 20.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextPrimary,
  );
}
