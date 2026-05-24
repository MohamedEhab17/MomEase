import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/formatter.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';
import 'package:new_mama/feature/auth/presentation/widgets/reset_password_form.dart';
import 'package:new_mama/feature/auth/presentation/widgets/reset_password_header.dart';
import 'package:new_mama/feature/auth/presentation/widgets/reset_password_otp_section.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  final String resetToken;

  const ResetPasswordView({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  String _otpCode = '';
  bool _isFormValid = false;

  int _seconds = 59;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _otpCode = widget.resetToken;
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _seconds = 59;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_seconds == 0) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final otpValid = _otpCode.length == 4;
    final passwordValid = validatePassword(_passwordController.text) == null;
    final confirmValid =
        validateConfirmPassword(
          _confirmPasswordController.text,
          _passwordController.text,
        ) ==
        null;
    setState(() {
      _isFormValid = otpValid && passwordValid && confirmValid;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().resetPassword(
      email: widget.email,
      otpCode: _otpCode,
      newPassword: _passwordController.text,
    );
  }

  void _handleResend() {
    _startTimer();
    context.read<AuthCubit>().forgotPassword(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          AppToast.success(
            context,
            title: 'Password Reset',
            message: state.message,
          );
          context.go(AppRoutesPaths.login);
        } else if (state is ResendOtpSuccess ||
            state is ForgotPasswordSuccess) {
          final message = state is ResendOtpSuccess
              ? state.message
              : (state as ForgotPasswordSuccess).message;
          AppToast.success(context, title: 'Code Resent', message: message);
        } else if (state is AuthError) {
          AppToast.error(context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
          child: Column(
            children: [
              const ResetPasswordHeader(),
              24.h.height,
              _buildEmailChip(context),
              32.h.height,
              ResetPasswordOtpSection(
                otpCode: _otpCode,
                canResend: _canResend,
                seconds: _seconds,
                onChanged: (value) {
                  _otpCode = value;
                  _validateForm();
                },
                onCompleted: (pin) {
                  _otpCode = pin;
                  _validateForm();
                },
                onResend: _handleResend,
              ),
              32.h.height,
              ResetPasswordForm(
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                onFormChanged: _validateForm,
              ),
              40.h.height,
              _buildSubmitButton(context),
              24.h.height,
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text('Reset Password', style: context.text.displaySmall!),
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 24.sp,
          color: context.colors.onSurface,
        ),
      ),
    );
  }

  Widget _buildEmailChip(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(
            Icons.mail_outline_rounded,
            size: 16.sp,
            color: context.colors.primary,
          ),
          8.w.width,
          Text(
            widget.email.maskEmail(),
            style: context.text.bodyMedium!.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: .clip,
            textDirection: .ltr,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Opacity(
          opacity: _isFormValid && !isLoading ? 1.0 : 0.5,
          child: CustomElevatedButton(
            text: 'Save & Reset Password',
            minimumSize: Size(double.infinity, 52.h),
            onPressed: _isFormValid && !isLoading ? _submit : null,
          ),
        );
      },
    );
  }
}
