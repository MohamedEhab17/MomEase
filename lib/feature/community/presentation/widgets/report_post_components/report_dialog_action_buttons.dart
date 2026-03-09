import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
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
            text: "Cancel",
            onPressed: () => context.pop(),
            backgroundColor: AppColors.lightBackground,
            padding: 14.vPadding,
            textStyle: AppStyles.styleInter12.copyWith(
              fontWeight: FontWeight.w600,
            ),
            borderColor: AppColors.primaryDark,
          ),
        ),
        16.width,
        Expanded(
          child: CustomElevatedButton(
            text: "Send",
            backgroundColor: AppColors.primaryDark,
            padding: 14.vPadding,
            textStyle: AppStyles.styleInter12.copyWith(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            onPressed: onSendReport,
          ),
        ),
      ],
    );
  }
}
