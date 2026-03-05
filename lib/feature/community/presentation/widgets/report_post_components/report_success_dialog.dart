import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/animated_dialog_container.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class ReportSuccessDialog extends StatefulWidget {
  const ReportSuccessDialog({super.key});

  @override
  State<ReportSuccessDialog> createState() => _ReportSuccessDialogState();
}

class _ReportSuccessDialogState extends State<ReportSuccessDialog> {
  void _onPressedContinue() {
    context.pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post reported successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogContainer(
      margin: 20.hPadding,
      padding: EdgeInsets.symmetric(horizontal: 52.w, vertical: 54.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(AppIcons.iconsSuccess, width: 120, height: 120),
          28.height,
          Text(
            "Report sent successfully!",
            style: AppStyles.styleInter20.copyWith(fontWeight: FontWeight.w600),
          ),
          7.height,
          Text(
            "Thank you for informing us!",
            style: AppStyles.styleInter12.copyWith(fontWeight: FontWeight.w400),
          ),
          32.height,
          CustomElevatedButton(
            text: "Continue",
            backgroundColor: AppColors.lightBackground,
            padding: 24.hPadding,
            textStyle: AppStyles.styleInter12.copyWith(
              fontWeight: FontWeight.w600,
            ),
            borderColor: AppColors.primaryHard,
            onPressed: _onPressedContinue,
          ),
        ],
      ),
    );
  }
}
