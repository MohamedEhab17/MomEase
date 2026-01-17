import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class EmailVerifiedSuccessWidget extends StatelessWidget {
  const EmailVerifiedSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 150.h, horizontal: 22.w),
        child: Column(
          children: [
            Text(
              'You’re all set',
              style: AppStyles.styleRoboto24.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            16.h.height,
            Text(
              'Thanks for confirming your email',
              style: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextDisabled,
                fontWeight: FontWeight.w400,
                fontSize: 20.sp,
              ),
            ),
            Spacer(),
            Lottie.asset(AppIcons.iconsSuccess, height: 190.h, width: 190.w),
            Spacer(),
            CustomElevatedButton(
              text: "Continue",
              minimumSize: Size(double.infinity, 52.h),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
