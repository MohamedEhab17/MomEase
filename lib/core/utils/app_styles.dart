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
  static TextStyle styleRoboto12 = TextStyle(
    fontSize: 12.sp,
    fontFamily: AppFontFamily.roboto,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextDisabled,
  );
  //! inter
  static TextStyle styleInter10 = TextStyle(
    fontSize: 10.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextPrimary.withAlpha(128),
  );
  static TextStyle styleInter16 = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextPrimary,
  );
  static TextStyle styleInter20 = TextStyle(
    fontSize: 20.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextPrimary,
  );
  static TextStyle styleInter32 = TextStyle(
    fontSize: 32.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
    color: AppColors.lightTextPrimary,
  );
  //! ScriptMT
  static TextStyle styleScriptMT32 = TextStyle(
    fontSize: 32.sp,
    fontFamily: AppFontFamily.scriptMT,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
}
