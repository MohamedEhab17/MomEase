import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/auth/widgets/custom_rich_text.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text('Verifiy Your Email', style: AppStyles.styleRoboto24),
      ),
      body: SingleChildScrollView(
        padding: 22.hPadding,
        child: Column(
          children: [
            64.h.height,
            CircleAvatar(
              radius: 96.r,
              backgroundColor: AppColors.accentSoft,
              child: Image.asset(
                AppImages.imagesEmailVerification,
                fit: BoxFit.contain,
              ),
            ),
            40.h.height,
            Text(
              'Please enter the code we sent to\nhe ******* nik@gmail.com',
              style: AppStyles.styleRoboto16,
              textAlign: TextAlign.center,
            ),
            37.h.height,
            Center(
              child: Pinput(
                length: 4,
                showCursor: true,
                onCompleted: (pin) => code = pin,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondarySoft2),
                    color: Colors.transparent,
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary),
                    color: Colors.transparent,
                  ),
                ),
                validator: (String? code) {
                  if (code!.isEmpty) {
                    return 'Please enter the verification code';
                  }
                  this.code = code;
                  return null;
                },
              ),
            ),
            24.h.height,
            TextButton(
              onPressed: () {},
              child: Text(
                'Resend Code',
                style: AppStyles.styleRoboto16.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                  decorationThickness: 2,
                ),
              ),
            ),
            50.h.height,
            CustomElevatedButton(
              text: "Verify Email",
              minimumSize: Size(double.infinity, 52.h),
              onPressed: () {
                context.go(AppRoutesPaths.emailVerifiedSuccess);
              },
            ),
            24.h.height,
            CustomRichText(
              firstText: "00:59 ",
              secondText: " Resend Verification Code",
              firstTextStyle: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
              secondTextStyle: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextDisabled,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? code;
}
