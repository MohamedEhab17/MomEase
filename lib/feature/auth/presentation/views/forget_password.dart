import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_circle_avatar.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late final TextEditingController _emailController;
  bool _isValid = false;

  void _validateEmail(String value) {
    final valid = validateEmailOrPhone(value) == null;
    if (valid != _isValid) {
      setState(() => _isValid = valid);
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
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            AppToast.success(
              context,
              title: 'Code Sent',
              message: 'Check your email for the reset code.',
            );
            // Navigate directly to reset password screen where user will enter OTP and new password
            context.push(
              AppRoutesPaths.resetPassword,
              extra: {'email': _emailController.text.trim()},
            );
          } else if (state is AuthError) {
            AppToast.error(context, message: state.message);
          }
        },
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: context.theme.appBarTheme.backgroundColor,
            scrolledUnderElevation: 0,
            title: Text(
              context.trContext(TK.authForgetAppBarTitle),
              style: context.text.displaySmall!,
            ),
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
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 48.h),
            child: Column(
              children: [
                CustomCircleAvatar(imagePath: AppImages.imagesForgetPassword),
                40.h.height,

                Text(
                  context.trContext(TK.authForgetInstructions),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: context.text.titleMedium!.copyWith(
                    color: context.ext.colors.lightTextDisabled,
                  ),
                ),

                40.h.height,

                TextFormFieldHelper(
                  hint: context.trContext(TK.authForgetEmailHint),
                  controller: _emailController,
                  fillColor: context.theme.cardColor,
                  hintStyle: context.text.titleMedium!.copyWith(
                    color: context.ext.colors.lightTextDisabled,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  borderRadius: BorderRadius.circular(64.r),
                  onChanged: (value) => _validateEmail(value ?? ''),
                  onValidate: validateEmailOrPhone,
                  autoFillHint: [AutofillHints.email],
                ),

                40.h.height,

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return Opacity(
                      opacity: _isValid && !isLoading ? 1.0 : 0.5,
                      child: CustomElevatedButton(
                        text: context.trContext(TK.authForgetSendCode),
                        minimumSize: Size(double.infinity, 52.h),
                        onPressed: _isValid && !isLoading
                            ? () {
                                FocusScope.of(context).unfocus();
                                context.read<AuthCubit>().forgotPassword(
                                  _emailController.text.trim(),
                                );
                              }
                            : null,
                      ),
                    );
                  },
                ),

                24.h.height,

                // Tip text
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
        ),
      ),
    );
  }
}
