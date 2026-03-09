import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final GlobalKey<AnimateFromState<dynamic>>? animateKey;
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.animateKey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 113.w,
        height: 30.h,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primaryLighter.withAlpha(77),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            animateKey != null
                ? AnimateFrom(
                    key: animateKey!,
                    child: SvgPicture.asset(icon, width: 16, height: 16),
                  )
                : SvgPicture.asset(icon, width: 16, height: 16),

            const SizedBox(width: 4),
            Text(
              label,
              style: AppStyles.styleInter12.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
