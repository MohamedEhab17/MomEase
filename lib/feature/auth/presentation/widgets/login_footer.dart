import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_rich_text.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
      return const SizedBox.shrink();
    }
    return CustomRichText(
      firstText: context.trContext(
        TK.authLoginNoAccountFirst,
      ),
      secondText: context.trContext(TK.authLoginSignUpLink),
      onTap: () {
        context.push(AppRoutesPaths.signup);
      },
      firstTextStyle: context.text.titleMedium!.copyWith(
        color: context.ext.colors.lightTextDisabled,
      ),
      secondTextStyle: context.text.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: context.ext.colors.primaryDark,
      ),
    );
  }
}
