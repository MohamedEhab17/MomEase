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

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
              76.h.height,
              CustomRichText(
                firstText: "Create an account, ",
                secondText: "Mama!",
                secondTextStyle: AppStyles.styleScriptMT32,

                center: false,
              ),
              8.h.height,
              Text(
                "Join us to start your journey!",
                style: AppStyles.styleRoboto16.copyWith(
                  color: AppColors.lightTextDisabled,
                  fontWeight: FontWeight.w500,
                ),
              ),
              56.h.height,
              Row(
                spacing: 24.w,
                children: [
                  Expanded(
                    child: TextFormFieldHelper(
                      hint: "First Name",
                      borderRadius: BorderRadius.circular(64),
                      onValidate: validateEmailOrPhone,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldHelper(
                      hint: "Last Name",
                      borderRadius: BorderRadius.circular(64),
                      onValidate: validateEmailOrPhone,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ],
              ),
              24.h.height,
              TextFormFieldHelper(
                hint: "Email",
                borderRadius: BorderRadius.circular(64),
                onValidate: validateEmailOrPhone,
                keyboardType: TextInputType.emailAddress,
              ),
              24.h.height,
              TextFormFieldHelper(
                hint: "Password",
                isPassword: true,
                borderRadius: BorderRadius.circular(64),
                onValidate: validatePassword,
                keyboardType: TextInputType.visiblePassword,
              ),
              24.h.height,
              TextFormFieldHelper(
                hint: "Confirm Password",
                isPassword: true,
                borderRadius: BorderRadius.circular(64),
                onValidate: (value) => validateConfirmPassword(value, ""),
                keyboardType: TextInputType.visiblePassword,
              ),
              48.h.height,
              CustomElevatedButton(
                text: "Sign Up",
                minimumSize: Size(double.infinity, 52),
                onPressed: () {
                  context.push(AppRoutesPaths.emailVerification);
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
                      firstText: "Already have an account? ",
                      secondText: "Login",
                      onTap: () => context.go(AppRoutesPaths.login),
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
