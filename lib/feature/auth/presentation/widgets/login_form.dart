import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onFormChanged;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          56.h.height,
          TextFormFieldHelper(
            controller: emailController,
            hint: context.trContext(TK.authLoginEmailHint),
            borderRadius: BorderRadius.circular(64),
            onValidate: validateEmailOrPhone,
            fillColor: context.theme.cardColor,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => onFormChanged(),
            autoFillHint: [AutofillHints.email],
          ),
          24.h.height,
          TextFormFieldHelper(
            controller: passwordController,
            hint: context.trContext(TK.authLoginPasswordHint),
            isPassword: true,
            borderRadius: BorderRadius.circular(64),
            onValidate: validatePassword,
            fillColor: context.theme.cardColor,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (_) => onFormChanged(),
            autoFillHint: [AutofillHints.password],
          ),
          8.h.height,
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: () {
                context.push(AppRoutesPaths.forgotPassword);
              },
              child: Text(
                context.trContext(TK.authForgotPassword),
                style: context.text.bodyLarge!.copyWith(
                  color: context.ext.colors.primaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
