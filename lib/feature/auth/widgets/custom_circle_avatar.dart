import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';


class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({super.key, required this.imagePath });
 final String imagePath;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.accentSoft,
      radius: 96.r,
      child: Image.asset(imagePath, fit: BoxFit.contain),
    );
  }
}
