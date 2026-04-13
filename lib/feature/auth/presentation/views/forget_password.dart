import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/enums/verification_type.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_circle_avatar.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late final TextEditingController _emailController ;

  bool isValid = false;

  void validateEmail(String value) {
    final valid = validateEmailOrPhone(value) == null;

    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        scrolledUnderElevation: 0,
        title: Text(context.trContext(TK.authForgetAppBarTitle), style: context.text.displaySmall!),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24.sp,
            color: context.colors.onSurface,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 64.h),
        child: Column(
          spacing: 40.h,
          children: [
            CustomCircleAvatar(imagePath: AppImages.imagesForgetPassword),

            Text(
              context.trContext(TK.authForgetInstructions),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: context.text.titleMedium!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
            ),

            TextFormFieldHelper(
              hint: context.trContext(TK.authForgetEmailHint),
              controller: _emailController,
              fillColor: context.theme.cardColor,
              hintStyle: context.text.titleMedium!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
              keyboardType: TextInputType.emailAddress,
              borderRadius: BorderRadius.circular(64.r),

              onChanged: (value) => validateEmail(value ?? ''),

              onValidate: validateEmailOrPhone,
            ),

            Opacity(
              opacity: isValid ? 1.0 : 0.5,
              child: CustomElevatedButton(
                text: context.trContext(TK.authForgetSendCode),
                minimumSize: Size(double.infinity, 52.h),
                onPressed: isValid
                    ? () {
                        FocusScope.of(context).unfocus();
                        context.push(
                          AppRoutesPaths.emailVerification,
                          extra: VerificationType.resetPassword,
                        );
                      }
                    : null,
              ),
            ),

            Text(
              context.trContext(TK.commonRetry),
              style: context.text.titleMedium!.copyWith(
                color: context.colors.primary,
                decoration: TextDecoration.underline,
                decorationThickness: 1.h,
                decorationColor: context.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
