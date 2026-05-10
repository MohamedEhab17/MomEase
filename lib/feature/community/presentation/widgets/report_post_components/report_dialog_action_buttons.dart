import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class ReportDialogActionButtons extends StatelessWidget {
  final VoidCallback onSendReport;

  const ReportDialogActionButtons({super.key, required this.onSendReport});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: context.trContext(TK.communityReportCancel),
            onPressed: () => context.pop(),
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
            text: context.trContext(TK.communityReportSend),
            backgroundColor: context.theme.buttonTheme.colorScheme!.primary,
            padding: 14.vPadding,
            textStyle: context.text.bodyLarge!.copyWith(
              color: context.theme.buttonTheme.colorScheme!.onPrimary,
              fontWeight: FontWeight.w600,
            ),
            onPressed: onSendReport,
          ),
        ),
      ],
    );
  }
}
