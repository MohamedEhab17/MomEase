import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:pinput/pinput.dart';

class VerificationOtpSection extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  const VerificationOtpSection({
    super.key,
    required this.onChanged,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: 4,
        showCursor: true,
        onChanged: onChanged,
        onCompleted: onCompleted,
        defaultPinTheme: PinTheme(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.ext.colors.greyExtraLight,
            ),
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
        submittedPinTheme: PinTheme(
          width: 56,
          height: 56,
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
    );
  }
}
