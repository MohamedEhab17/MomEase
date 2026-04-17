import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_rich_text.dart';

class VerificationFooter extends StatelessWidget {
  final VoidCallback onTap;

  const VerificationFooter({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRichText(
      firstText: context.trContext(
        TK.authVerificationDidntReceiveFirst,
      ),
      secondText: context.trContext(TK.authVerificationSpamLink),
      onTap: onTap,
      firstTextStyle: context.text.titleMedium!.copyWith(
        color: context.ext.colors.lightTextDisabled,
      ),
      secondTextStyle: context.text.titleMedium!.copyWith(
        color: context.ext.colors.primaryDark,
      ),
    );
  }
}
