import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:pinput/pinput.dart';

class ResetPasswordOtpSection extends StatelessWidget {
  final String otpCode;
  final bool canResend;
  final int seconds;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final VoidCallback onResend;

  const ResetPasswordOtpSection({
    super.key,
    required this.otpCode,
    required this.canResend,
    required this.seconds,
    required this.onChanged,
    required this.onCompleted,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Pinput(
            length: 4,
            showCursor: true,
            onChanged: onChanged,
            onCompleted: onCompleted,
            defaultPinTheme: PinTheme(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.ext.colors.greyExtraLight),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.ext.colors.primaryDark),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 56.w,
              height: 56.h,
              textStyle: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.primary),
                color: context.colors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
        ),
        16.h.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: canResend ? onResend : null,
              child: Text(
                context.trContext(TK.authResendCode),
                style: context.text.titleSmall!.copyWith(
                  color: canResend
                      ? context.colors.primary
                      : context.ext.colors.lightTextDisabled,
                  decoration: TextDecoration.underline,
                  decorationColor: canResend
                      ? context.colors.primary
                      : context.ext.colors.lightTextDisabled,
                ),
              ),
            ),
            8.w.width,
            Text(
              '00:${seconds.toString().padLeft(2, '0')}',
              style: context.text.bodySmall!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
