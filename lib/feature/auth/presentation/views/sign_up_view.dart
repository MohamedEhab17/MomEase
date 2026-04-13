import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/enums/verification_type.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_auth_options.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_rich_text.dart';
import 'package:new_mama/feature/auth/presentation/widgets/two_divider_separated_with_text.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  bool isValid = false;
  void validateForm() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          padding: EdgeInsetsDirectional.only(
            start: 16.w,
            end: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                76.h.height,
                CustomRichText(
                  firstText: context.trContext(TK.authSignUpTitleFirst),
                  secondText: context.trContext(TK.authSignUpTitleSecond),

                  center: false,
                ),
                8.h.height,
                Text(
                  context.trContext(TK.authSignUpSubtitle),
                  style: context.text.titleMedium!.copyWith(
                    color: context.ext.colors.lightTextDisabled,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                56.h.height,
                Row(
                  spacing: 24.w,
                  children: [
                    Expanded(
                      child: TextFormFieldHelper(
                        hint: context.trContext(TK.authSignUpFirstNameHint),
                        borderRadius: BorderRadius.circular(64),
                        onValidate: validateUsername,
                        keyboardType: TextInputType.name,
                        controller: _firstNameController,
                        fillColor: context.theme.cardColor,
                        onChanged: (_) => validateForm(),
                      ),
                    ),
                    Expanded(
                      child: TextFormFieldHelper(
                        hint: context.trContext(TK.authSignUpLastNameHint),
                        fillColor: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(64),
                        onValidate: validateUsername,
                        keyboardType: TextInputType.name,
                        controller: _lastNameController,
                        onChanged: (_) => validateForm(),
                      ),
                    ),
                  ],
                ),
                24.h.height,
                TextFormFieldHelper(
                  hint: context.trContext(TK.authSignUpEmailHint),
                  borderRadius: BorderRadius.circular(64),
                  onValidate: validateEmailOrPhone,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  fillColor: context.theme.cardColor,
                  onChanged: (_) => validateForm(),
                ),
                24.h.height,
                TextFormFieldHelper(
                  hint: context.trContext(TK.authSignUpPasswordHint),
                  isPassword: true,
                  borderRadius: BorderRadius.circular(64),
                  onValidate: validatePassword,
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  fillColor: context.theme.cardColor,
                  onChanged: (_) {
                    validateForm();
                    _formKey.currentState?.validate();
                  },
                ),
                24.h.height,
                TextFormFieldHelper(
                  hint: context.trContext(TK.authSignUpConfirmPasswordHint),
                  isPassword: true,
                  borderRadius: BorderRadius.circular(64),
                  fillColor: context.theme.cardColor,
                  controller: _confirmPasswordController,
                  onValidate: (value) =>
                      validateConfirmPassword(value, _passwordController.text),
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (_) => validateForm(),
                ),
                48.h.height,
                Opacity(
                  opacity: isValid ? 1.0 : 0.5,
                  child: CustomElevatedButton(
                    text: context.trContext(TK.authSignUpButton),

                    minimumSize: Size(double.infinity, 52),
                    onPressed: isValid
                        ? () {
                            context.push(
                              AppRoutesPaths.emailVerification,
                              extra: VerificationType.signup,
                            );
                          }
                        : null,
                  ),
                ),
                12.h.height,
                TwoDividerSeparatedWithText(text: context.trContext(TK.authSignUpOr)),
                24.h.height,
                CustomAuthOptions(),
                24.h.height,
                MediaQuery.of(context).viewInsets.bottom != 0.0
                    ? SizedBox.shrink()
                    : CustomRichText(
                        firstText: context.trContext(TK.authSignUpHasAccountFirst),
                        secondText: context.trContext(TK.authSignUpLoginLink),
                        onTap: () => context.pop(),
                        firstTextStyle: context.text.titleMedium!.copyWith(
                          color: context.ext.colors.lightTextDisabled,
                        ),
                        secondTextStyle: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.ext.colors.primaryDark,
                        ),
                      ),
                24.h.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
