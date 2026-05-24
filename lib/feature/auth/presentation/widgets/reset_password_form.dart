import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';

class ResetPasswordForm extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onFormChanged;

  const ResetPasswordForm({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldHelper(
          controller: passwordController,
          isPassword: true,
          hint: 'New Password',
          fillColor: context.theme.cardColor,
          borderRadius: BorderRadius.circular(64.r),
          onValidate: validatePassword,
          onChanged: (_) => onFormChanged(),
        ),
        16.h.height,
        TextFormFieldHelper(
          controller: confirmPasswordController,
          isPassword: true,
          hint: 'Confirm Password',
          fillColor: context.theme.cardColor,
          borderRadius: BorderRadius.circular(64.r),
          onValidate: (v) =>
              validateConfirmPassword(v, passwordController.text),
          onChanged: (_) => onFormChanged(),
        ),
      ],
    );
  }
}
