import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class CustomAuthOptions extends StatelessWidget {
  const CustomAuthOptions({
    super.key,
    this.googleOnPressed,
    this.facebookOnPressed,
    this.iconSize = 48,
    this.spacing = 48,
  });
  final void Function()? googleOnPressed;
  final void Function()? facebookOnPressed;
  final double iconSize;
  final double? spacing;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacing!.w,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: googleOnPressed,
          icon: SvgPicture.asset(
            AppIcons.iconsFacebook,
            width: iconSize.w,
            height: iconSize.h,
          ),
        ),

        IconButton(
          onPressed: googleOnPressed,
          icon: SvgPicture.asset(
            AppIcons.iconsGoogle,
            width: iconSize.w,
            height: iconSize.h,
          ),
        ),
      ],
    );
  }
}
