import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onFormChanged;

  const SignUpForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.ageController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        40.h.height,
        Row(
          spacing: 24.w,
          children: [
            Expanded(
              child: TextFormFieldHelper(
                hint: context.trContext(TK.authSignUpFirstNameHint),
                borderRadius: BorderRadius.circular(64),
                onValidate: validateUsername,
                keyboardType: TextInputType.name,
                controller: firstNameController,
                fillColor: context.theme.cardColor,
                onChanged: (_) => onFormChanged(),
              ),
            ),
            Expanded(
              child: TextFormFieldHelper(
                hint: context.trContext(TK.authSignUpLastNameHint),
                fillColor: context.theme.cardColor,
                borderRadius: BorderRadius.circular(64),
                onValidate: validateUsername,
                keyboardType: TextInputType.name,
                controller: lastNameController,
                onChanged: (_) => onFormChanged(),
              ),
            ),
          ],
        ),
        16.h.height,
        TextFormFieldHelper(
          hint: context.trContext(TK.authSignUpEmailHint),
          borderRadius: BorderRadius.circular(64),
          onValidate: validateEmailOrPhone,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          fillColor: context.theme.cardColor,
          onChanged: (_) => onFormChanged(),
        ),
        16.h.height,
        Row(
          spacing: 24.w,
          children: [
            Expanded(
              flex: 2,
              child: TextFormFieldHelper(
                hint: context.trContext(TK.authSignUpPhoneNumber),
                borderRadius: BorderRadius.circular(64),
                onValidate: (v) =>
                    v == null || v.isEmpty ? "Phone required" : null,
                keyboardType: TextInputType.phone,
                controller: phoneController,
                fillColor: context.theme.cardColor,
                onChanged: (_) => onFormChanged(),
              ),
            ),
            Expanded(
              child: TextFormFieldHelper(
                hint: context.trContext(TK.authSignUpAge),
                fillColor: context.theme.cardColor,
                borderRadius: BorderRadius.circular(64),
                onValidate: (v) => v == null || v.isEmpty ? "Required" : null,
                keyboardType: TextInputType.number,
                controller: ageController,
                onChanged: (_) => onFormChanged(),
              ),
            ),
          ],
        ),
        16.h.height,
        TextFormFieldHelper(
          hint: context.trContext(TK.authSignUpPasswordHint),
          isPassword: true,
          borderRadius: BorderRadius.circular(64),
          onValidate: validatePassword,
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          fillColor: context.theme.cardColor,
          onChanged: (_) => onFormChanged(),
        ),
        16.h.height,
        TextFormFieldHelper(
          hint: context.trContext(TK.authSignUpConfirmPasswordHint),
          isPassword: true,
          borderRadius: BorderRadius.circular(64),
          fillColor: context.theme.cardColor,
          controller: confirmPasswordController,
          onValidate: (value) => validateConfirmPassword(
            value,
            passwordController.text,
          ),
          keyboardType: TextInputType.visiblePassword,
          onChanged: (_) => onFormChanged(),
        ),
      ],
    );
  }
}
