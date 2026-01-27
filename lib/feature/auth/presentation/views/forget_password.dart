import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/auth/widgets/custom_circle_avatar.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.lightBackground,
        title: Text('Forget Password', style: AppStyles.styleRoboto24),
        leading: Icon(Icons.arrow_back_ios_new_rounded, size: 24.sp),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 64.h),
        child: Column(
          spacing: 40.h,
          children: [
            CustomCircleAvatar(imagePath: AppImages.imagesForgetPassword),
            Text(
              'Please enter your Email address to receive a verification code',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextDisabled,
              ),
            ),

            TextFormFieldHelper(
              hint: 'Email Address',
              hintStyle: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextDisabled,
              ),
              keyboardType: TextInputType.emailAddress,
              
              borderRadius: BorderRadius.circular(64.r),
            ),
            CustomElevatedButton(
              text: 'Send Code',
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              minimumSize: Size(double.infinity, 52.h),
            ),
            Text(
              'Try another way',
              style: AppStyles.styleRoboto16.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationThickness: 1.h,
                decorationColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
