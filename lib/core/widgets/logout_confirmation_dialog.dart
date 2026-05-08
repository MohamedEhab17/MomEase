import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/animated_dialog_container.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout_rounded,
            size: 80.r,
            color: context.colors.error,
          ),
          24.height,
          Text(
            context.trContext(TK.commonLogout),
            style: context.text.headlineSmall!.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          12.height,
          Text(
            context.trContext(TK.profileLogoutAccount), // Or a "Are you sure you want to logout?" key if exists
            style: context.text.bodyLarge!.copyWith(
              color: context.colors.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          32.height,
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: context.trContext(TK.childrenCancel),
                  onPressed: () => context.pop(false),
                  backgroundColor: context.colors.surface,
                  padding: 14.vPadding,
                  textStyle: context.text.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  borderColor: context.ext.colors.primaryDark,
                ),
              ),
              16.width,
              Expanded(
                child: CustomElevatedButton(
                  text: context.trContext(TK.commonLogout),
                  backgroundColor: context.colors.error,
                  padding: 14.vPadding,
                  textStyle: context.text.bodyLarge!.copyWith(
                    color: context.colors.onError,
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () => context.pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
