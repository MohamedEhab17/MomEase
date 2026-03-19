import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 24,
        children: [
          CustomElevatedButton(
            backgroundColor: AppColors.lightBackground,
            borderColor: AppColors.primary,
            text: "Logout Account",
            textStyle: AppStyles.styleInter16.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            minimumSize: Size(double.infinity, 52.h),
            onPressed: () {
              context.go(AppRoutesPaths.login);
            },
          ),
          Text(
            "MomEase V1.0.0",
            style: AppStyles.styleInter12.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
