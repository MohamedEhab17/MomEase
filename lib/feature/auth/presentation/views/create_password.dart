import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_circle_avatar.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool isValid = false;

  void validateForm() {
    final passwordValid = validatePassword(_passwordController.text) == null;

    final confirmValid =
        validateConfirmPassword(
          _confirmPasswordController.text,
          _passwordController.text,
        ) ==
        null;

    final valid = passwordValid && confirmValid;

    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        title: Text('Create New Password', style: context.text.displaySmall!),
        leading: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 24.sp,
          color: context.colors.onSurface,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 64.h),
        child: Column(
          children: [
            CustomCircleAvatar(imagePath: AppImages.imagesPassword),

            40.h.height,

            Text(
              'Your new password must be different from previously used password',
              style: context.text.titleLarge!,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),

            32.h.height,

            // PASSWORD
            TextFormFieldHelper(
              controller: _passwordController,
              isPassword: true,
              hint: 'New Password',
              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
              fillColor: context.theme.cardColor,
              borderRadius: BorderRadius.circular(64.r),

              onValidate: validatePassword,

              onChanged: (_) {
                validateForm();
              },
            ),

            24.h.height,

            // CONFIRM PASSWORD
            TextFormFieldHelper(
              controller: _confirmPasswordController,
              isPassword: true,
              hint: 'Confirm New Password',
              fillColor: context.theme.cardColor,
              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
              borderRadius: BorderRadius.circular(64.r),

              onValidate: (value) =>
                  validateConfirmPassword(value, _passwordController.text),

              onChanged: (_) {
                validateForm();
              },
            ),

            40.h.height,

            /// 🔘 BUTTON
            Opacity(
              opacity: isValid ? 1 : 0.5,
              child: CustomElevatedButton(
                text: 'Save',
                minimumSize: Size(double.infinity, 52.h),
                onPressed: isValid
                    ? () {
                        FocusScope.of(context).unfocus();
                        context.go(AppRoutesPaths.login);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password Updated')),
                        );

                        /// هنا API أو navigation
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
