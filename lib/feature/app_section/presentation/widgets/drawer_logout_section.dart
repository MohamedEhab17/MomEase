import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class DrawerLogoutSection extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback? onLogout;

  const DrawerLogoutSection({
    super.key,
    required this.animation,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(-40 * (1 - curved.value), 0),
          child: Opacity(
            opacity: curved.value.clamp(0.0, 1.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    backgroundColor: AppColors.backgroundPink,
                    borderColor: AppColors.primaryDark,

                    icon: Icon(
                      Icons.logout,
                      color: AppColors.primaryDark,
                      size: 20.sp,
                    ),
                    text: "Logout",
                    textStyle: AppStyles.styleInter16.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: onLogout ?? () {},
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'MomEase Version 1.0.0',
                  style: AppStyles.styleInter12.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
