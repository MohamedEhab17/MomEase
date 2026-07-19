import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/utils/app_icons.dart';

Widget buildDrawerIcon(String asset, {Color? color}) {
  return SvgPicture.asset(
    asset,
    width: 20.w,
    height: 20.w,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );
}

Widget buildDrawerChevron({Color? color}) {
  return SvgPicture.asset(
    AppIcons.iconsForwardArrow,
    width: 20.w,
    height: 20.w,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );
}
