import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

class VerificationTimerSection extends StatelessWidget {
  final bool canResend;
  final int seconds;
  final VoidCallback onResend;

  const VerificationTimerSection({
    super.key,
    required this.canResend,
    required this.seconds,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: canResend ? onResend : null,
          child: Text(
            context.trContext(TK.authResendCode),
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
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: context.text.titleMedium!.copyWith(
            color: canResend
                ? context.colors.primary
                : context.ext.colors.lightTextPrimary,
            fontWeight: canResend ? FontWeight.w600 : FontWeight.normal,
          ),
          child: Text(
            canResend
                ? context.trContext(TK.authVerificationResendNow)
                : '00:${seconds.toString().padLeft(2, '0')}',
          ),
        ),
      ],
    );
  }
}
