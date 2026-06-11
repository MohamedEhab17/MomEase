import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

/// Used in the forgot-password flow after OTP verification
/// to set a new password via the change-password endpoint.
/// For the reset-password flow (with email+OTP), use [ResetPasswordView].
class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isValid = false;

  void _validateForm() {
    final passwordValid = validatePassword(_passwordController.text) == null;
    final confirmValid = validateConfirmPassword(
          _confirmPasswordController.text,
          _passwordController.text,
        ) ==
        null;
    final valid = passwordValid && confirmValid;
    if (valid != _isValid) {
      setState(() => _isValid = valid);
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
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, next) => ModalRoute.of(context)?.isCurrent ?? false,
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          AppToast.success(
            context,
            title: 'Password Updated',
            message: state.message,
          );
          context.go(AppRoutesPaths.login);
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
            context.trContext(TK.authCreatePassword),
            style: context.text.displaySmall!,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24.sp,
              color: context.colors.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 48.h),
          child: Column(
            children: [
              CustomCircleAvatar(imagePath: AppImages.imagesPassword),
              40.h.height,

              Text(
                context.trContext(TK.authCreatePwdInstructions),
                style: context.text.titleLarge!,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),

              32.h.height,

              // New password
              TextFormFieldHelper(
                controller: _passwordController,
                isPassword: true,
                hint: context.trContext(TK.authCreatePwdNewHint),
                hintStyle: context.text.titleMedium!.copyWith(
                  color: context.ext.colors.lightTextDisabled,
                ),
                fillColor: context.theme.cardColor,
                borderRadius: BorderRadius.circular(64.r),
                onValidate: validatePassword,
                onChanged: (_) => _validateForm(),
              ),

              24.h.height,

              // Confirm password
              TextFormFieldHelper(
                controller: _confirmPasswordController,
                isPassword: true,
                hint: context.trContext(TK.authCreatePwdConfirmHint),
                fillColor: context.theme.cardColor,
                hintStyle: context.text.titleMedium!.copyWith(
                  color: context.ext.colors.lightTextDisabled,
                ),
                borderRadius: BorderRadius.circular(64.r),
                onValidate: (value) =>
                    validateConfirmPassword(value, _passwordController.text),
                onChanged: (_) => _validateForm(),
              ),

              40.h.height,

              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return Opacity(
                    opacity: _isValid && !isLoading ? 1 : 0.5,
                    child: CustomElevatedButton(
                      text: context.trContext(TK.authCreatePwdSaveButton),
                      minimumSize: Size(double.infinity, 52.h),
                      onPressed: _isValid && !isLoading
                          ? () {
                              FocusScope.of(context).unfocus();
                              context.read<AuthCubit>().changePassword(
                                    currentPassword: '',
                                    newPassword: _passwordController.text,
                                    confirmNewPassword:
                                        _confirmPasswordController.text,
                                  );
                            }
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}