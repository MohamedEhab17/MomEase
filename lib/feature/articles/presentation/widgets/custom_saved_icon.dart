
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class CustomSavedIcon extends StatefulWidget {
  const CustomSavedIcon({super.key});

  @override
  State<CustomSavedIcon> createState() => _CustomSavedIconState();
}

class _CustomSavedIconState extends State<CustomSavedIcon> {
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSaved = !isSaved;
        });
      },
      child: isSaved
          ? SvgPicture.asset(AppIcons.saveFilled, width: 12.w, height: 18.h)
          : SvgPicture.asset(
              AppIcons.iconsSaveNotFilled,
              width: 12.w,
              height: 18.h,
            ),
    );
  }
}
