import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class CustomQuickAccessCard extends StatelessWidget {
  const CustomQuickAccessCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.onTap, this.backgroundColor,
  });
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final String leadingIcon;
  final Color? backgroundColor;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
            blurStyle: BlurStyle.outer,
            color: AppColors.lightTextPrimary.withAlpha(38),
          ),
        ],
      ),

      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor: backgroundColor?? AppColors.primaryTint,
          child: SvgPicture.asset(leadingIcon),
        ),
        title: Text(title, style: AppStyles.styleInter12),
        subtitle: Text(
          subtitle,
          style: AppStyles.styleInter10.copyWith(
            color: AppColors.lightTextPrimary.withAlpha(178),
          ),
        ),
      ),
    );
  }
}
