import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/enums/verification_type.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_circle_avatar.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_rich_text.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerificationView extends StatefulWidget {
  final VerificationType type;

  const EmailVerificationView({super.key, required this.type});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  String code = '';
  bool isCodeComplete = false;

  int seconds = 59;
  bool canResend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    seconds = 59;
    canResend = false;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
        setState(() => canResend = true);
      } else {
        setState(() => seconds--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// 🎯 dynamic navigation
  void handleVerify() {
    if (widget.type == VerificationType.signup) {
      context.push(AppRoutesPaths.emailVerifiedSuccess);
    } else {
      context.push(AppRoutesPaths.createPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.colors.onSurface),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text("Verify Your Email", style: context.text.displaySmall!),
      ),
      body: SingleChildScrollView(
        padding: 22.hPadding,
        child: Column(
          children: [
            64.h.height,
            CustomCircleAvatar(imagePath: AppImages.imagesEmailVerification),
            40.h.height,

            Text(
              'Please enter the code we sent to\nhe ******* nik@gmail.com',
              style: context.text.titleLarge!,
              textAlign: TextAlign.center,
            ),

            37.h.height,

            /// 🔢 PIN INPUT
            Pinput(
              length: 4,
              showCursor: true,
              onChanged: (value) {
                setState(() {
                  code = value;
                  isCodeComplete = value.length == 4;
                });
              },
              onCompleted: (pin) {
                setState(() {
                  code = pin;
                  isCodeComplete = true;
                });
              },
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.ext.colors.greyExtraLight),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.ext.colors.primaryDark),
                ),
              ),
            ),

            24.h.height,

            /// 🔁 RESEND
            TextButton(
              onPressed: canResend ? startTimer : null,
              child: Text(
                'Resend Code',
                style: context.text.titleLarge!.copyWith(
                  color: canResend
                      ? context.ext.colors.primaryDark
                      : context.ext.colors.lightTextDisabled,
                  decoration: TextDecoration.underline,
                  decorationColor: canResend
                      ? context.ext.colors.primaryDark
                      : context.ext.colors.lightTextDisabled,
                ),
              ),
            ),

            8.h.height,

            // TIMER
            Text(
              canResend
                  ? "You can resend now"
                  : "00:${seconds.toString().padLeft(2, '0')}",
              style: context.text.titleMedium!.copyWith(
                color: context.ext.colors.lightTextPrimary,
              ),
            ),

            50.h.height,

            // VERIFY BUTTON
            Opacity(
              opacity: isCodeComplete ? 1 : 0.5,
              child: CustomElevatedButton(
                text: "Verify",
                minimumSize: Size(double.infinity, 52.h),
                onPressed: isCodeComplete ? handleVerify : null,
              ),
            ),

            24.h.height,

            CustomRichText(
              firstText: "Didn't receive code? ",
              secondText: "Check your spam",
              onTap: () => openEmailApp(context),
              firstTextStyle: context.text.titleMedium!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
              secondTextStyle: context.text.titleMedium!.copyWith(
                color: context.ext.colors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openEmailApp(BuildContext context) async {
    final Uri gmailApp = Uri.parse('googlegmail://');
    final Uri gmailWeb = Uri.parse('https://mail.google.com');

    try {
      if (await canLaunchUrl(gmailApp)) {
        await launchUrl(gmailApp);
      } else {
        await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Check your spam folder')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
