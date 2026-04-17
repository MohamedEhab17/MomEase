import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_rich_text.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        76.h.height,
        CustomRichText(
          firstText: context.trContext(TK.authSignUpTitleFirst),
          secondText: context.trContext(TK.authSignUpTitleSecond),
          center: false,
        ),
        8.h.height,
        Text(
          context.trContext(TK.authSignUpSubtitle),
          style: context.text.titleMedium!.copyWith(
            color: context.ext.colors.lightTextDisabled,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
