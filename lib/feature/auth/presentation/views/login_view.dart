import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                168.h.height,
                CustomRichText(
                  firstText: context.trContext(TK.authLoginWelcomeFirst),
                  secondText: context.trContext(TK.authLoginWelcomeSecond),
                  center: false,
                ),
                8.h.height,
                Text(
                  context.trContext(TK.authLogin),
                  style: context.text.titleMedium!.copyWith(
                    color: context.ext.colors.lightTextDisabled,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                56.h.height,
                TextFormFieldHelper(
                  controller: _emailController,
                  hint: context.trContext(TK.authLoginEmailPhoneHint),
                  borderRadius: BorderRadius.circular(64),
                  onValidate: validateEmailOrPhone,
                  fillColor: context.theme.cardColor,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => validateForm(),
                ),
                24.h.height,
                TextFormFieldHelper(
                  controller: _passwordController,
                  hint: context.trContext(TK.authLoginPasswordHint),
                  isPassword: true,
                  borderRadius: BorderRadius.circular(64),
                  onValidate: validatePassword,
                  fillColor: context.theme.cardColor,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (_) => validateForm(),
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
                48.h.height,
                Opacity(
                  opacity: isValid ? 1.0 : 0.5,
                  child: CustomElevatedButton(
                    text: "Login",
                    minimumSize: Size(double.infinity, 52),
                    onPressed: isValid
                        ? () {
                            context.go(AppRoutesPaths.appSectionView);
                          }
                        : null,
                  ),
                ),
                12.h.height,
                TwoDividerSeparatedWithText(text: context.trContext(TK.authLoginOr)),
                24.h.height,
                CustomAuthOptions(),
                24.h.height,
                MediaQuery.of(context).viewInsets.bottom != 0.0
                    ? SizedBox.shrink()
                    : CustomRichText(
                        firstText: context.trContext(TK.authLoginNoAccountFirst),
                        secondText: context.trContext(TK.authLoginSignUpLink),
                        onTap: () {
                          context.push(AppRoutesPaths.signup);
                        },
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
