import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.lightBackground,
        title: Text('Create New Password', style: AppStyles.styleRoboto24),
        leading: Icon(Icons.arrow_back_ios_new_rounded, size: 24.sp),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 64.h),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.accentSoft,
              radius: 96.r,
              child: Image.asset(AppImages.imagesPassword),
            ),
            40.h.height,
            Text(
              'Your new password must be different from previously used password',
              style: AppStyles.styleRoboto16,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            32.h.height,
            TextFormFieldHelper(
              isPassword: true,
              hint: 'New Password',
              hintStyle: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextDisabled,
              ),
              borderRadius: BorderRadius.circular(64.r),
            ),
            24.h.height,
            TextFormFieldHelper(
              isPassword: true,
              hint: 'Confirm New Password',
              hintStyle: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextDisabled,
              ),
              borderRadius: BorderRadius.circular(64.r),
            ),
            40.h.height,
            CustomElevatedButton(
              text: 'Save',
              onPressed: () {},
              minimumSize: Size(double.infinity, 52.h),
            ),
          ],
        ),
      ),
    );
  }
}
