import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/enums/verification_type.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/modal_progress_hud.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';
import 'package:new_mama/feature/auth/presentation/widgets/verification_footer.dart';
import 'package:new_mama/feature/auth/presentation/widgets/verification_header.dart';
import 'package:new_mama/feature/auth/presentation/widgets/verification_otp_section.dart';
import 'package:new_mama/feature/auth/presentation/widgets/verification_timer_section.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerificationView extends StatefulWidget {
  final VerificationType type;
  final String email;

  const EmailVerificationView({
    super.key,
    required this.type,
    required this.email,
  });

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  String _code = '';
  bool _isCodeComplete = false;

  int _seconds = 59;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 59;
    _canResend = false;

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
    super.dispose();
  }

  void _handleVerify() {
    context.read<AuthCubit>().verifyEmail(widget.email, _code);
  }

  void _handleResend() {
    _startTimer();
    context.read<AuthCubit>().resendOtp(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: 22.hPadding,
      child: Column(
        children: [
          VerificationHeader(email: widget.email),
          37.h.height,
          VerificationOtpSection(
            onChanged: (value) {
              setState(() {
                _code = value;
                _isCodeComplete = value.length == 4;
              });
            },
            onCompleted: (pin) {
              setState(() {
                _code = pin;
                _isCodeComplete = true;
              });
              _handleVerify();
            },
          ),
          24.h.height,
          VerificationTimerSection(
            canResend: _canResend,
            seconds: _seconds,
            onResend: _handleResend,
          ),
          50.h.height,
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return Opacity(
                opacity: _isCodeComplete && !isLoading ? 1 : 0.5,
                child: CustomElevatedButton(
                  text: context.trContext(TK.authVerificationVerifyButton),
                  minimumSize: Size(double.infinity, 52.h),
                  onPressed:
                      _isCodeComplete && !isLoading ? _handleVerify : null,
                ),
              );
            },
          ),
          24.h.height,
          VerificationFooter(onTap: () => _openEmailApp(context)),
          24.h.height,
        ],
      ),
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is EmailVerificationSuccess) {
          AppToast.success(
            context,
            title: 'Email Verified',
            message: 'Your email has been verified successfully.',
          );
          if (widget.type == VerificationType.signup) {
            context.go(AppRoutesPaths.emailVerifiedSuccess);
          } else {
            context.push(
              AppRoutesPaths.resetPassword,
              extra: {
                'email': widget.email,
                'resetToken': _code,
              },
            );
          }
        } else if (state is ResendOtpSuccess) {
          AppToast.success(
            context,
            title: 'Code Resent',
            message: state.message,
          );
        } else if (state is AuthError) {
          AppToast.error(context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: context.colors.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
          title: Text(
            context.trContext(TK.authVerifyEmail),
            style: context.text.displaySmall!,
          ),
        ),
        body: BlocSelector<AuthCubit, AuthState, bool>(
          selector: (state) => state is AuthLoading,
          builder: (context, isLoading) {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              child: body,
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEmailApp(BuildContext context) async {
    final Uri gmailApp = Uri.parse('googlegmail://');
    final Uri gmailWeb = Uri.parse('https://mail.google.com');

    try {
      if (await canLaunchUrl(gmailApp)) {
        await launchUrl(gmailApp);
      } else {
        await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
      }

      if (!context.mounted) return;
      AppToast.info(
        context,
        message: context.trContext(TK.authVerificationSpamSnackbar),
      );
    } catch (e) {
      if (!context.mounted) return;
      AppToast.error(
        context,
        message: context.trContext(
          TK.commonErrorWithDetails,
          namedArgs: {'error': '$e'},
        ),
      );
    }
  }
}
