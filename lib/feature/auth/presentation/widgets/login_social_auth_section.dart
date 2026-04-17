import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_auth_options.dart';
import 'package:new_mama/feature/auth/presentation/widgets/two_divider_separated_with_text.dart';

class LoginSocialAuthSection extends StatelessWidget {
  final VoidCallback onGooglePressed;

  const LoginSocialAuthSection({
    super.key,
    required this.onGooglePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TwoDividerSeparatedWithText(
          text: context.trContext(TK.authLoginOr),
        ),
        24.h.height,
        CustomAuthOptions(
          googleOnPressed: onGooglePressed,
        ),
      ],
    );
  }
}
