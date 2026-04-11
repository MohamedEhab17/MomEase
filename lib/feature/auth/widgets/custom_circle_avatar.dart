import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({super.key, required this.imagePath});
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.ext.colors.accentSoft,
      radius: 96.r,
      child: Image.asset(imagePath, fit: BoxFit.contain),
    );
  }
}
