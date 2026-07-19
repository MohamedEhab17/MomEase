import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class CustomCircleAvatarWithIcon extends StatelessWidget {
  const CustomCircleAvatarWithIcon({
    super.key,
    required this.image,
    required this.radius,
    required this.width,
    required this.height,
  });
  final String image;
  final double radius;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.ext.colors
          .primaryLighter,
      radius: radius.r,
      child: SvgPicture.asset(
        image,
        height: height.h,
        width: width.w,
        colorFilter: ColorFilter.mode( context.ext.colors.primaryDark, BlendMode.srcIn),
      ),
    );
  }
}
