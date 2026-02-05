import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/auth/widgets/custom_auth_options.dart';
import 'package:new_mama/feature/auth/widgets/custom_rich_text.dart';
import 'package:new_mama/feature/auth/widgets/two_divider_separated_with_text.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              168.h.height,
              CustomRichText(
                firstText: "Welcome Back, ",
                secondText: "Mama!",
                center: false,
                secondTextStyle: AppStyles.styleScriptMT32,
              ),
              8.h.height,
              Text(
                "Login to continue your journey!",
                style: AppStyles.styleRoboto16.copyWith(
                  color: AppColors.lightTextDisabled,
                  fontWeight: FontWeight.w500,
                ),
              ),
              56.h.height,
              TextFormFieldHelper(
                hint: "Email/Phone",
                borderRadius: BorderRadius.circular(64),
                onValidate: validateEmailOrPhone,
              ),
              24.h.height,
              TextFormFieldHelper(
                hint: "Password",
                isPassword: true,
                borderRadius: BorderRadius.circular(64),
                onValidate: validatePassword,
              ),
              8.h.height,
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: AppStyles.styleRoboto12.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              48.h.height,
              CustomElevatedButton(
                text: "Login",
                minimumSize: Size(double.infinity, 52),
                onPressed: () {
                  context.go(AppRoutesPaths.appSectionView);
                },
              ),
              12.h.height,
              TwoDividerSeparatedWithText(text: "Or"),
              24.h.height,
              CustomAuthOptions(),
              24.h.height,
              MediaQuery.of(context).viewInsets.bottom != 0.0
                  ? SizedBox.shrink()
                  : CustomRichText(
                      firstText: "Don't have an account? ",
                      secondText: "Sign Up",
                      onTap: () {
                        context.go(AppRoutesPaths.signup);
                      },
                      firstTextStyle: AppStyles.styleRoboto16.copyWith(
                        color: AppColors.lightTextDisabled,
                      ),
                      secondTextStyle: AppStyles.styleRoboto16.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
              24.h.height,
            ],
          ),
        ),
      ),
    );
  }
}
